(() => {
    const toc = document.getElementById("page-toc");
    const nav = toc.querySelector("nav");
    // Keep active-section tracking aligned with the visible outline depth.
    const entries = [...nav.querySelectorAll("a[href^='#']")]
        .filter(link => {
            let depth = 0;
            for (let node = link.parentElement; node !== nav; node = node.parentElement) {
                if (node.tagName === "UL") depth++;
            }
            return depth <= Number(toc.dataset.depth);
        })
        .map(link => ({
            link,
            section: link.hash
                ? document.getElementById(decodeURIComponent(link.hash.slice(1)))
                : document.querySelector("div.body"),
        }));
    const desktop = window.matchMedia("(min-width: 941px)");
    let current;
    let pending = false;

    function update() {
        pending = false;
        let active = entries[0];
        for (const entry of entries) {
            if (entry.section.getBoundingClientRect().top > 120) break;
            active = entry;
        }
        if (!active || active === current) return;
        if (current) current.link.removeAttribute("aria-current");
        active.link.setAttribute("aria-current", "location");
        current = active;

        // Scroll only the sidebar, never the document (or a keyboard-focused link).
        if (desktop.matches && !toc.contains(document.activeElement)) {
            const sidebar = toc.closest(".sphinxsidebar");
            const box = active.link.getBoundingClientRect();
            const bounds = sidebar.getBoundingClientRect();
            if (box.top < bounds.top || box.bottom > bounds.bottom) {
                sidebar.scrollTop += box.top - bounds.top - sidebar.clientHeight / 2;
            }
        }
    }

    function schedule() {
        if (!pending) {
            pending = true;
            requestAnimationFrame(update);
        }
    }

    function setLayout() {
        toc.open = desktop.matches;
        current = undefined;
        nav.querySelectorAll("[aria-current]").forEach(link => link.removeAttribute("aria-current"));
        schedule();
    }

    desktop.addEventListener("change", setLayout);
    setLayout();
    nav.addEventListener("click", event => {
        if (!desktop.matches && event.target.closest("a")) toc.open = false;
    });
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule);
    window.addEventListener("hashchange", schedule);
    window.addEventListener("load", schedule);
    // Opening a recording or Config block can move the current heading.
    document.addEventListener("toggle", schedule, true);
    update();
})();
