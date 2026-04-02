import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loader"]
  static values = { resultsContainer: String }

  connect() {
    this.setupResultsObserver()
  }

  setupResultsObserver() {
    const resultsContainer = document.getElementById(this.resultsContainerValue)
    
    if (!resultsContainer) {
      console.warn("Results container not found:", this.resultsContainerValue)
      return
    }

    const existingResults = resultsContainer.querySelectorAll('.provider-result')
    if (existingResults.length > 0) {
      this.hideLoader()
      return
    }

    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        if (mutation.addedNodes.length > 0) {
          const hasProviderResults = Array.from(mutation.addedNodes).some(node => {
            return node.querySelectorAll('.provider-result').length > 0 ||
                   (node.classList && node.classList.contains('provider-result'))
          })
          
          if (hasProviderResults) {
            this.hideLoader()
            observer.disconnect()
          }
        }
      })
    })

    observer.observe(resultsContainer, {
      childList: true,
      subtree: true
    })
  }

  hideLoader() {
    this.loaderTarget.style.display = "none"
  }
}