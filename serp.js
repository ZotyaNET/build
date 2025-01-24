(() => {
    const results = {
        sponsored: [],
        organic: []
    };

    // Helper function to get element position
    const getElementPosition = (element) => {
        const rect = element.getBoundingClientRect();
        return {
            x: rect.left + window.scrollX,
            y: rect.top + window.scrollY
        };
    };

    // Helper function to get sitelinks
    const getSitelinks = (element) => {
        const sitelinks = [];
        const sitelinkElements = element.querySelectorAll('a');
        sitelinkElements.forEach((sitelink) => {
            const title = sitelink.innerText;
            const url = sitelink.href;
            if (title && url) {
                sitelinks.push({
                    title: title,
                    url: url,
                    position: getElementPosition(sitelink)
                });
            }
        });
        return sitelinks;
    };

    // Get sponsored links
    const sponsoredElements = document.querySelectorAll('div[data-text-ad]');
    sponsoredElements.forEach((element) => {
        const linkElement = element.querySelector('a');
        const descriptionElement = element.querySelector('div[role="heading"] + div');
        const descriptionText = descriptionElement ? descriptionElement.innerText.split('\n') : ['', ''];

        results.sponsored.push({
            link: linkElement.href,
            advertiser_name: descriptionText[0],
            advertiser_link: descriptionText[1],
            position: getElementPosition(linkElement),
            sitelinks: getSitelinks(element)
        });
    });

    // Get organic links
    const organicElements = document.querySelectorAll('div#search .g');
    organicElements.forEach((element) => {
        const linkElement = element.querySelector('a');
        const headingElement = element.querySelector('h3');
        const descriptionElement = element.querySelector('.IsZvec');

        results.organic.push({
            link: linkElement.href,
            heading: headingElement ? headingElement.innerText : '',
            description: descriptionElement ? descriptionElement.innerText : '',
            position: getElementPosition(linkElement),
            sitelinks: getSitelinks(element)
        });
    });

    return results;
})();
