const houseCardsContainer = document.querySelector("[house-cards-container]")
const houseCardTemplate = document.querySelector("[house-card-template]")
const searchInput = document.querySelector("[houses-search]")

let houses = []

searchInput.addEventListener("input", e => {
    const value = e.target.value.toLowerCase().trim()

    houses.forEach(house => {
        const isVisible = house.name.toLowerCase().includes(value) || 
                        house.address.toLowerCase().includes(value)
        house.element.classList.toggle("hide", !isVisible)
    })
})

fetch("/housesdata/")
    .then(response => response.json())
    .then(data => {
        houses = data.data.map(house => {
            const card = houseCardTemplate.content.cloneNode(true).children[0]
            const carouselSlide = card.querySelector("[carousel-slide]")
            const cardBody = card.querySelector("[card-body]")
            const title = card.querySelector("[house-name]")
            const priceRange = card.querySelector("[price-range]")
            const address = card.querySelector("[house-address]")

            /** Taking the image template of a single card */
            const cardImageContainer = card.querySelector("[card-image-container]")
            const imageTemplate = card.querySelector("[house-image-template]")
            /** Carousel indecator of the corresponding image */
            const carouselIndicatorContainer = card.querySelector("[indicators-container]")
            const carouselIndicatorTemplate = card.querySelector("[indicator-template]")

            carouselSlide.id = "carousel" + house.HOUSE_ID
            
            title.textContent = house.HOUSE_NAME
            address.textContent = house.CITY_NAME + ', ' + house.COUNTRY_NAME

            fetch("/housePriceRange/" + house.HOUSE_ID)
            .then(responsePrice => responsePrice.json())
            .then(prices => {
                let minPrice = prices.minPrice
                let maxPrice = prices.maxPrice
                let price = ''
                
                if(minPrice && maxPrice)
                    if(minPrice == maxPrice)
                        price = '$' + minPrice
                    else
                        price = '$' + minPrice + '-' + maxPrice

                priceRange.textContent = price
            })

            /** Iterate throgh all the images of a house */
            fetch("/housePhotosPath/" + house.HOUSE_ID)
            .then(responsePath => responsePath.json())
            .then(values => {
                let active = true
                
                let count = 0
                paths = values.paths.map(path => {
                    const imageDiv = imageTemplate.content.cloneNode(true).children[0]
                    const image = imageDiv.querySelector("[house-image]")
                    const button = carouselIndicatorTemplate.content.cloneNode(true).children[0]

                    image.src = path.PATH
                    if(active) {
                        image.parentElement.classList.add('active')
                        button.classList.add('active')
                        button.setAttribute("aria-current", "true")
                        active = false
                    }

                    button.setAttribute("data-bs-target", "#carousel" + house.HOUSE_ID)
                    button.setAttribute("data-bs-slide-to", "" + count)
                    count += 1
                    button.setAttribute("aria-label", "Slide " + count)

                    carouselIndicatorContainer.append(button)
                    cardImageContainer.append(imageDiv)

                    return {housePath: path.PATH}
                })
            })
            
            card.querySelectorAll("[data-bs-target]").forEach(element => {
                element.setAttribute("data-bs-target", "#carousel" + house.HOUSE_ID)
            })

            cardBody.onclick = function() {
                console.log("Clicked")
                location.href = "/house/" + house.HOUSE_ID
            }

            houseCardsContainer.append(card)

            return {name: house.HOUSE_NAME, 
                    address: house.CITY_NAME + ', ' + house.COUNTRY_NAME,
                    element: card}
        })

        $('.carousel').carousel({
            interval: false,
        });
    })