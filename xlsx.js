const fileInput = document.createElement('input');
fileInput.type = 'file';
fileInput.accept = '.xlsx';
fileInput.style.display = 'none';
document.body.appendChild(fileInput);

fileInput.addEventListener('change', () => {
    const file = fileInput.files[0];
    if (!file) {
        console.error('No file selected.');
        return;
    }

    loadXLSXLibrary(() => {
        const reader = new FileReader();
        reader.onload = function(event) {
            const data = new Uint8Array(event.target.result);
            const workbook = XLSX.read(data, { type: 'array' });
            const firstSheetName = workbook.SheetNames[0];
            const worksheet = workbook.Sheets[firstSheetName];
            const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 });

            // Extract the first column as items
            const items = jsonData.map(row => row[0]).filter(Boolean); // Remove empty rows
            console.log('Items:', items);

            // Call the download function with the parsed items
            download(items);
        };

        reader.onerror = function() {
            console.error('Failed to read the file.');
        };

        reader.readAsArrayBuffer(file); // Read the file as an ArrayBuffer
    });
});

// Trigger the file input dialog
fileInput.click();

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

function download(items) {
    // console.log('Processing items:', items);
    runProductScript(items);
}

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