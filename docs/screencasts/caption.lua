-- Caption + keycast overlays, intended for asciinema screencasts.
--
-- ____________________________________________________________________________
-- WARNING:
-- This file was written by Claude Opus 5 with the Pi harness. The code has NOT
-- been extensively manually reviewed. However, its functionality has been
-- tested extensively in practice, and the risk of being wrong is in screencast
-- annotations that look funky, so I'm not *that* worried..
-- ____________________________________________________________________________
--
-- Both floats are drawn from RPC calls made by /gifs/lib.sh while the recorded
-- nvim is otherwise idle in getchar(), which is why every function ends with an
-- explicit `redraw` -- nvim will not repaint on its own while blocked.

local M = {}

-- Anchor name -> float position. Anchors are nvim's own corner semantics, so
-- e.g. NE means "the box's north-east corner sits at (row, col)".
local function place(anchor, w, h)
  local col_r = vim.o.columns - 2
  local row_b = vim.o.lines - 2
  local pos = {
    NE = { row = 1,     col = col_r },
    NW = { row = 1,     col = 2 },
    SE = { row = row_b, col = col_r },
    SW = { row = row_b, col = 2 },
  }
  local p = pos[anchor] or pos.NE
  return { relative = 'editor', anchor = pos[anchor] and anchor or 'NE',
           row = p.row, col = p.col, width = w, height = h,
           style = 'minimal', border = 'rounded', focusable = false,
           noautocmd = true, zindex = 300 }
end

-- Greedy word wrap on display width. Words longer than `width` are hard-split
-- so a long path or command can never blow out the box.
local function wrap(text, width)
  local out = {}
  -- honour both real newlines and the literal "\n" that survives shell quoting
  text = text:gsub('\\n', '\n')
  for para in (text .. '\n'):gmatch('([^\n]*)\n') do
    local line = ''
    for word in para:gmatch('%S+') do
      while vim.fn.strdisplaywidth(word) > width do
        local head = vim.fn.strcharpart(word, 0, width - 1) .. '-'
        if line ~= '' then out[#out + 1] = line; line = '' end
        out[#out + 1] = head
        word = vim.fn.strcharpart(word, width - 1)
      end
      local cand = (line == '') and word or (line .. ' ' .. word)
      if vim.fn.strdisplaywidth(cand) <= width then
        line = cand
      else
        out[#out + 1] = line
        line = word
      end
    end
    out[#out + 1] = line
  end
  -- drop trailing blank produced by the sentinel newline
  while #out > 1 and out[#out] == '' do out[#out] = nil end
  return out
end

-- Max caption text width: g:cap_width_frac of the terminal, clamped sanely.
-- NB: vim.g.* is nil when unset, and tonumber(nil) is not portable across
-- Lua/LuaJIT versions, so check the type first.
local function cap_width()
  local g = vim.g.cap_width_frac
  local frac = (type(g) == 'number' and g) or (type(g) == 'string' and tonumber(g)) or 0.45
  local w = math.floor(vim.o.columns * frac)
  return math.max(18, math.min(w, vim.o.columns - 6))
end

-- Resolve a highlight group through any `link` chain. Returns {} on failure so
-- callers can always index the result.
local function resolve(name)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or type(hl) ~= 'table' then return {} end
  hl.link = nil
  return hl
end

-- Derive the caption's text/border groups from an accent group (Diagnostic*).
-- `nvim_set_hl` cannot add attributes on top of a `link`, so the colours are
-- copied out explicitly. Re-derived on every draw: a colorscheme change between
-- steps would otherwise leave these stale.
--
-- g:cap_style selects the look:
--   'reverse' (default) -- accent colour as *background*, i.e. a solid block.
--                          Much louder than bold at GIF resolution, and does
--                          not depend on the render font shipping a bold face.
--   'bold'              -- accent-coloured bold text on the normal background.
local function style_hl(text_name, border_name, src)
  local accent = resolve(src).fg
  local base = resolve('Normal').bg
    or (vim.o.background == 'light' and 0xffffff or 0x000000)
  local style = (type(vim.g.cap_style) == 'string' and vim.g.cap_style) or 'reverse'
  if style == 'reverse' then
    -- Explicit fg/bg swap rather than `reverse = true`: the float's own Normal
    -- fills the whole window rect, so this paints the padding as well as the
    -- glyphs, and the border is tinted to match so the box reads as one slab.
    pcall(vim.api.nvim_set_hl, 0, text_name, { fg = base, bg = accent, bold = true })
    pcall(vim.api.nvim_set_hl, 0, border_name, { fg = accent, bg = base })
  else
    pcall(vim.api.nvim_set_hl, 0, text_name, { fg = accent, bg = base, bold = true })
    pcall(vim.api.nvim_set_hl, 0, border_name, { fg = accent, bg = base })
  end
end

-- forward declaration: float() closes stale floats, and close() is defined below
local close

local function float(state, lines, anchor, hl)
  local w = 0
  for _, l in ipairs(lines) do w = math.max(w, vim.fn.strdisplaywidth(l)) end
  local padded = {}
  for i, l in ipairs(lines) do padded[i] = '  ' .. l .. '  ' end
  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    state.buf = vim.api.nvim_create_buf(false, true)
  end
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, padded)
  local cfg = place(anchor, w + 4, #padded)
  -- Floats belong to a tabpage. If the script moved to another tab (e.g.
  -- ':tab Git'), the existing float is stranded where nobody can see it, and
  -- reconfiguring it silently draws off-screen -- so drop it and reopen here.
  if state.win and vim.api.nvim_win_is_valid(state.win)
     and vim.api.nvim_win_get_tabpage(state.win) ~= vim.api.nvim_get_current_tabpage() then
    close(state)
  end
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    -- 'noautocmd' is open-only: nvim_win_set_config() errors with E5108 if it is
    -- present, which used to abort every caption update after the first one.
    cfg.noautocmd = nil
    vim.api.nvim_win_set_config(state.win, cfg)
  else
    state.win = vim.api.nvim_open_win(state.buf, false, cfg)
  end
  vim.wo[state.win].winhl = hl
end

function close(state)
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end
  state.win = nil
end

-- Window/buffer handles live in a persistent global so a hot-reload (dofile)
-- does not orphan floats that are already on screen.
_G.__CAPSTATE = _G.__CAPSTATE or { cap = {}, keys = {} }

-- ---------------------------------------------------------------- captions --
M.cap = _G.__CAPSTATE.cap

-- Exposed for debugging: :lua =CAPWRAP('some long text', 30)
_G.CAPWRAP = wrap
_G.CAPWIDTH = cap_width

-- Traces and errors from RPC-driven floats are invisible to the shell (it only
-- sees a failed remote-expr), so record them where they can be found.
local function log_err(what, err)
  pcall(function()
    local f = io.open('/tmp/caption.log', 'a')
    if f then f:write(os.date('%H:%M:%S '), what, ': ', tostring(err), '\n'); f:close() end
  end)
end

-- CAP(text[, anchor]) -- '' clears. Wraps to multiple lines as needed.
_G.CAP = function(text, anchor)
  if text == nil or text == '' then
    close(M.cap); vim.cmd('redraw'); return ''
  end
  local ok, err = pcall(function()
    local w = cap_width()
    local lines = wrap(text, w)
    style_hl('CapText', 'CapBorder', 'DiagnosticInfo')
    float(M.cap, lines, anchor or 'NE',
          'Normal:CapText,FloatBorder:CapBorder')
    -- geometry trace: /tmp/caption.log is the ground truth when a caption
    -- looks wrong in the recording
    local cfg = vim.api.nvim_win_get_config(M.cap.win)
    log_err('CAP', string.format(
      'len=%d cap_width=%d nlines=%d anchor=%s w=%d h=%d row=%s col=%s cols=%d :: %s',
      vim.fn.strdisplaywidth(text), w, #lines, tostring(cfg.anchor),
      cfg.width, cfg.height, tostring(cfg.row), tostring(cfg.col),
      vim.o.columns, text))
  end)
  if not ok then log_err('CAP ERROR', err) end
  vim.cmd('redraw')                  -- essential: nvim is blocked in getchar
  return ''
end

vim.cmd [[function! Cap(t, ...) abort
  return luaeval('CAP(_A[1], _A[2])', [a:t, get(a:000, 0, 'NE')])
endfunction]]

-- ----------------------------------------------------------------- keycast --
M.keys = _G.__CAPSTATE.keys
local ktimer

-- KEYS(text[, anchor]) -- transient float showing the keystrokes being sent.
_G.KEYS = function(text, anchor)
  if text == nil or text == '' then
    close(M.keys); vim.cmd('redraw'); return ''
  end
  local ok, err = pcall(function()
    style_hl('KeysText', 'KeysBorder', 'DiagnosticHint')
    float(M.keys, wrap(text, cap_width()), anchor or 'SE',
          'Normal:KeysText,FloatBorder:KeysBorder')
  end)
  if not ok then log_err('KEYS ERROR', err) end
  vim.cmd('redraw')
  -- auto-hide so the keycast doesn't linger into the next step
  if ktimer then pcall(function() ktimer:stop(); ktimer:close() end); ktimer = nil end
  ktimer = vim.defer_fn(function() close(M.keys); pcall(vim.cmd, 'redraw') end, 1200)
  return ''
end

vim.cmd [[function! Keys(t, ...) abort
  return luaeval('KEYS(_A[1], _A[2])', [a:t, get(a:000, 0, 'SE')])
endfunction]]

return M
