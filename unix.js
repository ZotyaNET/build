function download(items) {
    // Load the XLSX library
    loadXLSXLibrary(() => {
        runProductScript(items);
    });
}

function loadXLSXLibrary(callback) {
    if (typeof XLSX === 'undefined') {
        const script = document.createElement('script');
        script.src = 'https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.0/xlsx.full.min.js';
        script.onload = function() {
            console.log('XLSX library loaded!');
            if (typeof callback === 'function') {
                callback(); // Execute the callback after the library is loaded
            }
        };
        script.onerror = function() {
            console.error('Failed to load XLSX library.');
        };
        document.head.appendChild(script);
    } else {
        console.log('XLSX library already loaded!');
        if (typeof callback === 'function') {
            callback(); // Execute the callback if the library is already loaded
        }
    }
}

// Your main script to fetch, parse and download as Excel
async function runProductScript(items) {

    let allProducts = [];

    for (const item of items) {
        console.log('Making AJAX request for:', item);
        const url = `https://www.unixauto.hu/autoalkatresz?handler=SzavadSzavasPartial&cKerString=${encodeURIComponent(item)}&lTeljEgy=true&lNemRend=true`;

        try {
            const response = await fetch(url);
            const responseText = await response.text();
            const parsedData = parseProductData(item, responseText);
            allProducts = allProducts.concat(parsedData);
            console.log('Parsed data:', parsedData);
        } catch (error) {
            console.error('AJAX request failed:', error);
        }
    }

    // After all items are processed, create and download the Excel file
    createAndDownloadExcel(allProducts);
}

function parseProductData(id, html) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const productSections = doc.querySelectorAll('.product--quick-search');
    const products = [];

    productSections.forEach((section) => {
        const product = {};
        const isoTimestamp = new Date().toISOString();
        product.timestamp = isoTimestamp;
        product.query = id;

        const title = section.querySelector('.product__title')?.textContent.trim();
        if (title) product.title = title;

        const linkElement = section.querySelector('.product__block--title a');
        if (linkElement) product.url = 'https://www.unixauto.hu' + linkElement.getAttribute('href');

        const imgElement = section.querySelector('.product__thumbnail img');
        if (imgElement) product.image = imgElement.getAttribute('src');

        const priceElement = section.querySelector('.price__amount');
        if (priceElement) {
            const price = priceElement.textContent.trim();
            if (price) product.price = price;
        }

        section.querySelectorAll('img[alt]').forEach((img) => {
            const altText = img.getAttribute('alt').trim();

            if (altText.startsWith('Központi raktár:')) {
                const storeCentral = altText.replace('Központi raktár:', '').trim();
                if (storeCentral) product.store_central = storeCentral;
            } else if (altText.startsWith('Unix Szentendre:')) {
                const storeSzentendre = altText.replace('Unix Szentendre:', '').trim();
                if (storeSzentendre) product.store_szentendre = storeSzentendre;
            }
        });

        products.push(product);
    });

    return products;
}

function createAndDownloadExcel(products) {
    if (typeof XLSX === 'undefined') {
        console.error("XLSX library is not loaded.");
        return;
    }

    const ws = XLSX.utils.json_to_sheet(products);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, "Products");

    const wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });
    const buf = new ArrayBuffer(wbout.length);
    const view = new Uint8Array(buf);
    for (let i = 0; i < wbout.length; i++) {
        view[i] = wbout.charCodeAt(i) & 0xFF;
    }

    const blob = new Blob([buf], { type: 'application/octet-stream' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = 'unix.xlsx';
    link.click();
    console.log('Download triggered!');
}

// const items = [
// "TEXTAR 92326003",
// "TEXTAR 92326103",
// "TEXTAR 92326305",
// "TEXTAR 92326905",
// "TEXTAR 92337703",
// "TEXTAR 92337905",
// "TEXTAR 92341103",
// "TEXTAR 92346705",
// "TEXTAR 93012400",
// "TEXTAR 93123403",
// "TEXTAR 93123503",
// "TEXTAR 93143203",
// "TEXTAR 93143303",
// "TEXTAR 93240600",
// "TEXTAR 93260603",
// "TEXTAR 94014800",
// "TEXTAR 94024300",
// "TEXTAR 94031500",
// "TEXTAR 94046500",
// "TEXTAR 95002100",
// "TEXTAR 95002200",
// "TEXTAR 95002300",
// "TEXTAR 95002400",
// "TEXTAR 95006100",
// "TEXTAR 95006200",
// "TEXTAR 95006600",
// "TEXTAR 96000200",
// "TEXTAR 97011800",
// "TEXTAR 98023300",
// "TEXTAR 98024701",
// "TEXTAR 98040100",
// "TEXTAR 98043100",
// "TEXTAR 98044100",
// "TEXTAR 98044300",
// "TEXTAR 98044500",
// "TEXTAR 98045400",
// "TEXTAR 98046200",
// "TEXTAR 98046501",
// "TEXTAR 98048700"
// ];
//
// download(items);