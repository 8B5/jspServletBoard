(() => {
    const root = document.documentElement;
    const hero = document.querySelector(".hero-section-compact");
    const cursorLight = document.createElement("div");

    cursorLight.style.position = "fixed";
    cursorLight.style.pointerEvents = "none";
    cursorLight.style.width = "320px";
    cursorLight.style.height = "320px";
    cursorLight.style.borderRadius = "50%";
    cursorLight.style.background = "radial-gradient(circle, rgba(0,245,255,0.35), transparent 70%)";
    cursorLight.style.mixBlendMode = "screen";
    cursorLight.style.opacity = "0.18";
    cursorLight.style.transition = "opacity 0.3s ease";
    cursorLight.style.zIndex = "0";

    document.body.appendChild(cursorLight);

    let rafId = null;
    const handleMouseMove = ({ clientX, clientY }) => {
        if (rafId) cancelAnimationFrame(rafId);
        rafId = requestAnimationFrame(() => {
            cursorLight.style.transform = `translate(${clientX - 160}px, ${clientY - 160}px)`;
            cursorLight.style.opacity = "0.24";
        });
    };

    const handleMouseLeave = () => {
        cursorLight.style.opacity = "0.12";
    };

    window.addEventListener("mousemove", handleMouseMove);
    window.addEventListener("mouseleave", handleMouseLeave);

    // Hero glitch text effect
    if (hero) {
        const title = hero.querySelector(".hero-title-compact");
        if (title) {
            const original = title.textContent;
            const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

            const glitch = () => {
                let iteration = 0;
                const interval = setInterval(() => {
                    title.textContent = original
                        .split("")
                        .map((char, index) => {
                            if (char === " " || char === "-" || char === "_") return char;
                            if (index < iteration) return original[index];
                            return chars[Math.floor(Math.random() * chars.length)];
                        })
                        .join("");

                    iteration += 1;
                    if (iteration >= original.length) {
                        clearInterval(interval);
                        title.textContent = original;
                    }
                }, 60);
            };

            setTimeout(glitch, 600);
            setInterval(glitch, 9000);
        }
    }
})();



