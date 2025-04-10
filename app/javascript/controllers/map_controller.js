import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="map"
export default class extends Controller {
  static values = {
    apiKey: String,
    markers: Array,
    logoUrl: String
  }

  connect() {
    console.log("Stimulus Map-Controller verbunden ✅")
    mapboxgl.accessToken = this.apiKeyValue

    this.map = new mapboxgl.Map({
      container: this.element, // Direkt auf das Element, an dem der Controller hängt, zugreifen
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()

    this.map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    }))
  }

  #addMarkersToMap() {
    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.className = "custom-marker"
      customMarker.dataset.spatiId = marker.id // Späti ID zum Marker hinzufügen

      const image = document.createElement("img")
      image.src = this.logoUrlValue
      image.alt = "Späti-Marker"
      image.className = "marker-image"

      customMarker.appendChild(image)

      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)

      // Event-Listener hinzufügen, um beim Klick die Card anzuzeigen
      customMarker.addEventListener("click", () => {
        this.showSpatiCard(marker.id);
      })
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker =>
      bounds.extend([marker.lng, marker.lat])
    )
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  // Diese Methode wird aufgerufen, wenn auf einen Marker geklickt wird
  showSpatiCard(spatiId) {
    const spatiCard = document.getElementById(`spati-card-${spatiId}`);
    if (spatiCard) {
      spatiCard.classList.remove("hidden"); // Card sichtbar machen
    }
  }

  showCurrentLocation() {
    if (!this.map) return

    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        const lng = position.coords.longitude
        const lat = position.coords.latitude

        new mapboxgl.Marker({ color: "blue" })
          .setLngLat([lng, lat])
          .addTo(this.map)

        this.map.flyTo({
          center: [lng, lat],
          zoom: 14
        })
      }, () => {
        alert("Standort konnte nicht ermittelt werden.")
      })
    } else {
      alert("Geolocation wird von deinem Browser nicht unterstützt.")
    }
  }
}
