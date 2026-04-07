import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader"]
  static values = { resultsContainer: String }

  connect() {
    const container = document.getElementById(this.resultsContainerValue)
    if (!container) return

    if (container.querySelector(".search-result")) {
      this.hideLoader()
      return
    }

    this.observer = new MutationObserver(() => {
      if (container.querySelector(".search-result")) {
        this.hideLoader()
        this.observer.disconnect()
      }
    })

    this.observer.observe(container, { childList: true, subtree: true })
  }

  disconnect() {
    this.observer?.disconnect()
  }

  hideLoader() {
    this.loaderTarget.style.display = "none"
  }
}