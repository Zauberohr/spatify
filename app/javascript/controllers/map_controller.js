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
      container: this.element,
      style: "mapbox://styles/mapbox/streets-v10"
    })

    this.#addMarkersToMap()
    this.#fitMapToMarkers()
    this.#addGeocoderControl()
    this.#addLocateButton()
  }

  #addMarkersToMap() {
    console.log("Logo-URL im Controller:", this.logoUrlValue)

    this.markersValue.forEach((marker) => {
      const popup = new mapboxgl.Popup().setHTML(marker.info_window_html)

      const customMarker = document.createElement("div")
      customMarker.className = "custom-marker"

      const image = document.createElement("img")
      image.src = this.logoUrlValue
      image.alt = "Späti-Marker"
      image.className = "marker-image"

      customMarker.appendChild(image)

      new mapboxgl.Marker(customMarker)
        .setLngLat([marker.lng, marker.lat])
        .setPopup(popup)
        .addTo(this.map)

      console.log("Marker gesetzt bei:", marker.lng, marker.lat)
    })
  }

  #fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds()
    this.markersValue.forEach(marker =>
      bounds.extend([marker.lng, marker.lat])
    )
    this.map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 })
  }

  #addGeocoderControl() {
    this.map.addControl(new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      mapboxgl: mapboxgl
    }))
  }

  #addLocateButton() {
    const button = document.createElement("button")
    button.textContent = "📍"
    button.className = "locate-button"

    button.addEventListener("click", () => {
      if (!navigator.geolocation) {
        alert("Geolocation wird von deinem Browser nicht unterstützt.")
        return
      }

      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userCoords = [position.coords.longitude, position.coords.latitude]

          new mapboxgl.Marker({ color: "red" })
            .setLngLat(userCoords)
            .setPopup(new mapboxgl.Popup().setHTML("Du bist hier 🥴"))
            .addTo(this.map)
            .togglePopup()

          this.map.flyTo({ center: userCoords, zoom: 16 })
        },
        () => {
          alert("Standort konnte nicht ermittelt werden – bist du vielleicht zu betrunken?")
        }
      )
    })

    this.element.appendChild(button)
  }
}
