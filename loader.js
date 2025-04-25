// ModelClass holds data
class ModelClass {
    constructor(data = {}) {
        Object.assign(this, data);
    }
}

// JsonFileView allows downloading a model as a JSON file
class JsonFileView {
    constructor(model) {
        this.model = model;
    }

    download(filename = 'data.json') {
        const json = JSON.stringify(this.model, null, 2);
        const blob = new Blob([json], { type: 'application/json' });
        const url = URL.createObjectURL(blob);

        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        a.click();

        URL.revokeObjectURL(url);
    }
}

// ModalView displays a modal dialog with title, message, and a button
class ModalView {
    constructor(title = 'Notice', message = '', buttonLabel = 'OK') {
        this.title = title;
        this.message = message;
        this.buttonLabel = buttonLabel;
    }

    show() {
        const modalOverlay = document.createElement('div');
        modalOverlay.style.position = 'fixed';
        modalOverlay.style.top = '0';
        modalOverlay.style.left = '0';
        modalOverlay.style.width = '100vw';
        modalOverlay.style.height = '100vh';
        modalOverlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
        modalOverlay.style.display = 'flex';
        modalOverlay.style.alignItems = 'center';
        modalOverlay.style.justifyContent = 'center';
        modalOverlay.style.zIndex = '10000';

        const modalBox = document.createElement('div');
        modalBox.style.backgroundColor = '#fff';
        modalBox.style.padding = '20px';
        modalBox.style.borderRadius = '8px';
        modalBox.style.maxWidth = '400px';
        modalBox.style.boxShadow = '0 2px 10px rgba(0,0,0,0.2)';
        modalBox.innerHTML = `
      <h2 style="margin-top: 0;">${this.title}</h2>
      <p>${this.message}</p>
    `;

        const button = document.createElement('button');
        button.textContent = this.buttonLabel;
        button.style.marginTop = '10px';
        button.style.padding = '10px 20px';
        button.style.border = 'none';
        button.style.backgroundColor = '#007BFF';
        button.style.color = '#fff';
        button.style.borderRadius = '4px';
        button.style.cursor = 'pointer';

        button.onclick = () => document.body.removeChild(modalOverlay);

        modalBox.appendChild(button);
        modalOverlay.appendChild(modalBox);
        document.body.appendChild(modalOverlay);
    }
}

// ModelView displays any ModelClass instance as a key-value list
class ModelView {
    constructor(model) {
        this.model = model;
    }

    show(container = document.body) {
        const wrapper = document.createElement('div');
        wrapper.style.border = '1px solid #ddd';
        wrapper.style.padding = '15px';
        wrapper.style.margin = '10px 0';
        wrapper.style.borderRadius = '6px';
        wrapper.style.background = '#f9f9f9';
        wrapper.style.fontFamily = 'sans-serif';
        wrapper.style.maxWidth = '400px';

        const title = document.createElement('h3');
        title.textContent = 'Model Data';
        wrapper.appendChild(title);

        for (const key in this.model) {
            const item = document.createElement('div');
            item.style.marginBottom = '8px';

            const label = document.createElement('strong');
            label.textContent = key + ': ';
            item.appendChild(label);

            const value = document.createElement('span');
            value.textContent = this.model[key];
            item.appendChild(value);

            wrapper.appendChild(item);
        }

        container.appendChild(wrapper);
    }
}

// DataTablesView displays model data in a DataTables-powered table
class DataTablesView {
    constructor(models) {
        this.models = models;
    }

    show(container = document.body) {
        // Create table structure
        const table = document.createElement('table');
        table.style.width = '100%';
        table.style.borderCollapse = 'collapse';
        table.style.marginTop = '20px';
        table.style.border = '1px solid #ddd';

        container.appendChild(table);

        // Create header row
        const header = document.createElement('thead');
        const headerRow = document.createElement('tr');
        if (this.models.length > 0) {
            Object.keys(this.models[0]).forEach(key => {
                const th = document.createElement('th');
                th.textContent = key.charAt(0).toUpperCase() + key.slice(1); // Capitalize key
                th.style.padding = '8px';
                th.style.border = '1px solid #ddd';
                th.style.textAlign = 'left';
                headerRow.appendChild(th);
            });
        }
        header.appendChild(headerRow);
        table.appendChild(header);

        // Create body rows
        const body = document.createElement('tbody');
        this.models.forEach(model => {
            const row = document.createElement('tr');
            Object.values(model).forEach(value => {
                const td = document.createElement('td');
                td.textContent = value;
                td.style.padding = '8px';
                td.style.border = '1px solid #ddd';
                row.appendChild(td);
            });
            body.appendChild(row);
        });
        table.appendChild(body);

        // Handle sorting
        const ths = table.querySelectorAll('th');
        ths.forEach((th, index) => {
            th.onclick = () => this.sortTable(table, index);
        });
    }

    sortTable(table, columnIndex) {
        const rows = Array.from(table.querySelectorAll('tbody tr'));
        const isAscending = table.querySelectorAll('th')[columnIndex].classList.contains('ascending');

        rows.sort((rowA, rowB) => {
            const cellA = rowA.cells[columnIndex].textContent;
            const cellB = rowB.cells[columnIndex].textContent;

            return (isAscending ? cellA > cellB : cellA < cellB) ? 1 : -1;
        });

        rows.forEach(row => table.querySelector('tbody').appendChild(row));

        table.querySelectorAll('th').forEach(th => th.classList.remove('ascending', 'descending'));
        table.querySelectorAll('th')[columnIndex].classList.add(isAscending ? 'descending' : 'ascending');
    }
}

// Example usage:
const carParts = [
    new ModelClass({ id: 1, name: 'Brake Pad', price: 49.99, inStock: true }),
    new ModelClass({ id: 2, name: 'Oil Filter', price: 19.99, inStock: false }),
    new ModelClass({ id: 3, name: 'Air Filter', price: 29.99, inStock: true })
];

// View it as JSON file
const jsonView = new JsonFileView(carParts[0]);
// jsonView.download(); // Uncomment to test download

// Show modal popup
const modal = new ModalView('Product Info', 'Car part loaded successfully!', 'Nice');
modal.show();

// Visual model viewer
const viewer = new ModelView(carParts[0]);
viewer.show();

// DataTablesView to display car parts in a table
const dataTableView = new DataTablesView(carParts);
dataTableView.show();
class Controller {
    constructor() {
        this.carParts = [];
    }

    // Map method: Maps HTML form input data to a car part
    map(htmlData) {
        const carPart = {
            name: htmlData.name || '',
            partNumber: htmlData.partNumber || '',
            manufacturer: htmlData.manufacturer || '',
            price: parseFloat(htmlData.price) || 0,
            stock: parseInt(htmlData.stock, 10) || 0
        };

        this.carParts.push(carPart);
    }

    // Display the mapped car parts in the console
    showCarParts() {
        console.table(this.carParts);
    }
}

// Example usage
const controller = new Controller();

// Example HTML data (could come from a form submission, etc.)
const htmlData1 = {
    name: "Brake Disc",
    partNumber: "BD123",
    manufacturer: "XYZ Corp",
    price: "150.00",
    stock: "100"
};

const htmlData2 = {
    name: "Headlight",
    partNumber: "HL456",
    manufacturer: "ABC Inc.",
    price: "80.00",
    stock: "50"
};

// Map data to car parts
controller.map(htmlData1);
controller.map(htmlData2);

// Show the mapped car parts
controller.showCarParts();
