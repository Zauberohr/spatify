document.addEventListener("DOMContentLoaded", () => {
  const logoContainer = document.querySelector(".logo-container");

  if (logoContainer) {
    setTimeout(() => {
      logoContainer.classList.add("fade-out");
    }, 500); // Startet die Animation nach 0,5 Sekunden
  }
});
