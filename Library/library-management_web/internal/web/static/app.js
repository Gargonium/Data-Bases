let token = null;
let role = null;
let currentReaderId = null;
let currentEmployeeId = null;

const API_BASE = '/api';

async function apiRequest(url, options = {}) {
    const headers = { 'Content-Type': 'application/json', ...options.headers };
    if (token) headers['Authorization'] = `Bearer ${token}`;
    const response = await fetch(API_BASE + url, { ...options, headers });
    if (!response.ok) {
        const errorText = await response.text();
        throw new Error(errorText || `HTTP ${response.status}`);
    }
    if (response.status === 204) return null;
    return response.json();
}

function renderNav() {
    const nav = document.getElementById('navMenu');
    if (!nav) return;
    nav.innerHTML = '';
    const tabs = [];

    if (role === 'admin' || role === 'librarian') {
        tabs.push({ id: 'readers', label: 'Читатели', view: renderReaders });
        tabs.push({ id: 'publications', label: 'Публикации', view: renderPublications });
        tabs.push({ id: 'loans', label: 'Выдача/Возврат', view: renderLoans });
        tabs.push({ id: 'queries', label: 'Отчёты', view: renderQueries });
    }
    if (role === 'reader') {
        tabs.push({ id: 'myLoans', label: 'Мои книги', view: renderMyLoans });
        tabs.push({ id: 'search', label: 'Поиск книг', view: renderSearch });
    }

    tabs.forEach(tab => {
        const btn = document.createElement('button');
        btn.className = 'nav-link';
        btn.textContent = tab.label;
        btn.onclick = () => {
            document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
            btn.classList.add('active');
            tab.view();
        };
        nav.appendChild(btn);
    });
    if (tabs.length) tabs[0].view();
}

// ----- РАЗДЕЛ АДМИНИСТРАТОРА / БИБЛИОТЕКАРЯ -----
async function renderReaders() {
    const content = document.getElementById('content');
    content.innerHTML = `
        <div class="card">
            <div class="card-header d-flex justify-content-between">
                <h4>Читатели</h4>
                <button id="addReaderBtn" class="btn btn-sm btn-success">+ Добавить читателя</button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped" id="readersTable">
                        <thead><tr><th>ID</th><th>Фамилия</th><th>Имя</th><th>Категория</th><th>Библиотека</th><th>Действия</th></tr></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    `;
    const readers = await apiRequest('/readers?limit=100');
    const tbody = document.querySelector('#readersTable tbody');
    tbody.innerHTML = '';
    readers.forEach(r => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${r.id}</td>
            <td>${r.last_name}</td>
            <td>${r.first_name}</td>
            <td>${r.category_name || r.category_id}</td>
            <td>${r.library_name || r.library_id}</td>
            <td><button class="btn btn-sm btn-danger delete-reader" data-id="${r.id}">Удалить</button></td>
        `;
        tbody.appendChild(tr);
    });
    document.getElementById('addReaderBtn').onclick = () => showReaderModal();
    document.querySelectorAll('.delete-reader').forEach(btn => {
        btn.onclick = async () => {
            if (confirm('Удалить читателя?')) {
                await apiRequest(`/readers/${btn.dataset.id}`, { method: 'DELETE' });
                renderReaders();
            }
        };
    });
}

async function showReaderModal(reader = null) {
    // Загружаем списки категорий и библиотек
    let categories = [], libraries = [];
    try {
        categories = await apiRequest('/reader-categories');
        libraries = await apiRequest('/libraries');
    } catch(e) { alert('Не удалось загрузить справочники'); return; }
    const catList = categories.map(c => `${c.id} - ${c.name}`).join(', ');
    const libList = libraries.map(l => `${l.id} - ${l.name}`).join(', ');

    const firstName = prompt('Имя:', reader ? reader.first_name : '');
    if (!firstName) return;
    const lastName = prompt('Фамилия:', reader ? reader.last_name : '');
    if (!lastName) return;
    const categoryId = prompt(`ID категории (доступны: ${catList}):`, reader ? reader.category_id : '');
    if (!categoryId) return;
    const libraryId = prompt(`ID библиотеки (доступны: ${libList}):`, reader ? reader.library_id : '');
    if (!libraryId) return;

    const method = reader ? 'PUT' : 'POST';
    const url = reader ? `/readers/${reader.id}` : '/readers';
    try {
        await apiRequest(url, {
            method,
            body: JSON.stringify({ first_name: firstName, last_name: lastName, category_id: parseInt(categoryId), library_id: parseInt(libraryId) })
        });
        renderReaders();
    } catch(e) { alert('Ошибка: ' + e.message); }
}

async function renderPublications() {
    const content = document.getElementById('content');
    content.innerHTML = `
        <div class="card">
            <div class="card-header d-flex justify-content-between">
                <h4>Публикации</h4>
                <button id="addPubBtn" class="btn btn-sm btn-success">+ Добавить</button>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table" id="pubTable">
                        <thead><tr><th>ID</th><th>Название</th><th>Издатель</th><th>Дата</th><th>Действия</th></tr></thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    `;
    const pubs = await apiRequest('/publications');
    const tbody = document.querySelector('#pubTable tbody');
    tbody.innerHTML = pubs.map(p => `
        <tr>
            <td>${p.id}</td>
            <td>${p.title}</td>
            <td>${p.publisher}</td>
            <td>${p.publish_date}</td>
            <td><button class="btn btn-sm btn-danger delete-pub" data-id="${p.id}">Удалить</button></td>
        </tr>
    `).join('');
    document.getElementById('addPubBtn').onclick = () => {
        const title = prompt('Название:');
        if (!title) return;
        const publisher = prompt('Издатель:');
        if (!publisher) return;
        const date = prompt('Дата (ГГГГ-ММ-ДД):');
        if (!date || !/^\d{4}-\d{2}-\d{2}$/.test(date)) {
            alert('Неверный формат даты. Используйте ГГГГ-ММ-ДД');
            return;
        }
        apiRequest('/publications', {
            method: 'POST',
            body: JSON.stringify({ title, publisher, publish_date: date })
        }).then(() => renderPublications()).catch(e => alert(e.message));
    };
    document.querySelectorAll('.delete-pub').forEach(btn => {
        btn.onclick = async () => {
            if (confirm('Удалить публикацию?')) {
                await apiRequest(`/publications/${btn.dataset.id}`, { method: 'DELETE' });
                renderPublications();
            }
        };
    });
}

async function renderLoans() {
    const content = document.getElementById('content');
    // Для администратора показываем все выдачи
    if (role === 'admin') {
        content.innerHTML = `<div class="card"><div class="card-header">Все выдачи</div><div class="card-body"><div id="allLoansList">Загрузка...</div></div></div>`;
        try {
            const loans = await apiRequest('/loans/all?limit=200');
            const container = document.getElementById('allLoansList');
            if (loans.length === 0) container.innerHTML = '<p>Нет выдач</p>';
            else container.innerHTML = loans.map(l => `
                <div>Выдача #${l.id} - читатель ${l.reader_id}, экз. ${l.copy_inventory_number}, выдал сотрудник ${l.issued_employee_id}, выдана ${l.date_of_issue}, срок ${l.expire_date}${l.return_date ? ' (возвращена)' : ''}</div>
            `).join('');
        } catch(e) { document.getElementById('allLoansList').innerHTML = '<p>Ошибка загрузки</p>'; }
        return;
    }
    // Для библиотекаря
    if (!currentEmployeeId) {
        const empId = prompt('Ваш employee_id (из таблицы employee):', '1');
        if (!empId) return;
        currentEmployeeId = parseInt(empId);
    }
    content.innerHTML = `
        <div class="row">
            <div class="col-md-6">
                <div class="card"><div class="card-header">Выдача книги</div><div class="card-body">
                    <input type="number" id="readerId" class="form-control mb-2" placeholder="ID читателя">
                    <input type="number" id="copyInv" class="form-control mb-2" placeholder="Инвентарный номер">
                    <button id="issueBtn" class="btn btn-primary">Выдать</button>
                </div></div>
            </div>
            <div class="col-md-6">
                <div class="card"><div class="card-header">Возврат книги</div><div class="card-body">
                    <input type="number" id="loanId" class="form-control mb-2" placeholder="ID выдачи">
                    <button id="returnBtn" class="btn btn-warning">Вернуть</button>
                </div></div>
            </div>
        </div>
        <div class="card mt-4"><div class="card-header">Активные выдачи</div><div class="card-body"><div id="activeLoansList"></div></div></div>
    `;
    document.getElementById('issueBtn').onclick = async () => {
        const reader_id = parseInt(document.getElementById('readerId').value);
        const copy_inventory_number = parseInt(document.getElementById('copyInv').value);
        if (isNaN(reader_id) || isNaN(copy_inventory_number)) { alert('Введите числа'); return; }
        try {
            await apiRequest('/loans', { method: 'POST', body: JSON.stringify({ reader_id, copy_inventory_number, issued_employee_id: currentEmployeeId }) });
            alert('Книга выдана');
            loadActiveLoans();
        } catch(e) { alert('Ошибка: ' + e.message); }
    };
    document.getElementById('returnBtn').onclick = async () => {
        const id = parseInt(document.getElementById('loanId').value);
        if (isNaN(id)) { alert('Введите ID выдачи'); return; }
        try {
            await apiRequest(`/loans/${id}/return`, { method: 'PUT' });
            alert('Книга возвращена');
            loadActiveLoans();
        } catch(e) { alert('Ошибка: ' + e.message); }
    };
    const loadActiveLoans = async () => {
        try {
            const loans = await apiRequest('/loans/active');
            const container = document.getElementById('activeLoansList');
            container.innerHTML = loans.map(l => `<div>Выдача #${l.id} - читатель ${l.reader_id}, экз. ${l.copy_inventory_number}, срок до ${l.expire_date}</div>`).join('');
        } catch(e) { document.getElementById('activeLoansList').innerHTML = '<p>Ошибка загрузки</p>'; }
    };
    loadActiveLoans();
}

async function renderQueries() {
    const content = document.getElementById('content');
    content.innerHTML = `
        <div class="card"><div class="card-header"><h4>Отчёты (16 запросов)</h4></div><div class="card-body">
            <select id="querySelect" class="form-select mb-2">
                <option value="1">1. Читатели по атрибуту</option>
                <option value="2">2. Читатели с произведением на руках</option>
                <option value="3">3. Читатели с изданием на руках</option>
                <option value="4">4. Читатели, бравшие издание с произведением за период</option>
                <option value="5">5. Издания из своей библиотеки за период</option>
                <option value="6">6. Издания из чужой библиотеки за период</option>
                <option value="7">7. Выдано с полки</option>
                <option value="8">8. Обслужены библиотекарем</option>
                <option value="9">9. Выработка библиотекарей</option>
                <option value="10">10. Просроченные выдачи</option>
                <option value="11">11. Движение экземпляров</option>
                <option value="12">12. Сотрудники в читальном зале</option>
                <option value="13">13. Неактивные читатели</option>
                <option value="14">14. Экземпляры произведения</option>
                <option value="15">15. Экземпляры автора</option>
                <option value="16">16. Популярные произведения</option>
            </select>
            <div id="queryParams"></div>
            <button id="runQueryBtn" class="btn btn-primary mt-2">Выполнить</button>
            <div id="queryResult" class="mt-3"><pre></pre></div>
        </div></div>
    `;
    const querySelect = document.getElementById('querySelect');
    const paramsDiv = document.getElementById('queryParams');
    const updateParams = () => {
        const val = querySelect.value;
        paramsDiv.innerHTML = '';
        if (val === '1') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="catId" placeholder="category_id"><input class="form-control mb-1" id="attrName" placeholder="attr_name"><input class="form-control mb-1" id="attrVal" placeholder="attr_value">`;
        } else if (val === '2') {
            paramsDiv.innerHTML = `<input class="form-control" id="workId" placeholder="work_id">`;
        } else if (val === '3') {
            paramsDiv.innerHTML = `<input class="form-control" id="pubId" placeholder="publication_id">`;
        } else if (val === '4') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="workId" placeholder="work_id"><input class="form-control mb-1" id="dateFrom" type="date"><input class="form-control mb-1" id="dateTo" type="date">`;
        } else if (val === '5' || val === '6') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="readerId" placeholder="reader_id"><input class="form-control mb-1" id="dateFrom" type="date"><input class="form-control mb-1" id="dateTo" type="date">`;
        } else if (val === '7') {
            paramsDiv.innerHTML = `<input class="form-control" id="shelfId" placeholder="shelf_id">`;
        } else if (val === '8') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="empId" placeholder="employee_id"><input class="form-control mb-1" id="dateFrom" type="date"><input class="form-control mb-1" id="dateTo" type="date">`;
        } else if (val === '9' || val === '11' || val === '13') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="dateFrom" type="date"><input class="form-control mb-1" id="dateTo" type="date">`;
        } else if (val === '12') {
            paramsDiv.innerHTML = `<input class="form-control mb-1" id="libId" placeholder="library_id"><input class="form-control mb-1" id="roomId" placeholder="reading_room_id">`;
        } else if (val === '14') {
            paramsDiv.innerHTML = `<input class="form-control" id="workId" placeholder="work_id">`;
        } else if (val === '15') {
            paramsDiv.innerHTML = `<input class="form-control" id="authorId" placeholder="author_id">`;
        } else {
            paramsDiv.innerHTML = '';
        }
    };
    querySelect.addEventListener('change', updateParams);
    updateParams();
    document.getElementById('runQueryBtn').onclick = async () => {
        const val = querySelect.value;
        let url = '';
        const getVal = (id) => document.getElementById(id)?.value;
        if (val === '1') url = `/queries/readers-by-attribute?category_id=${getVal('catId')}&attr_name=${getVal('attrName')}&attr_value=${getVal('attrVal')}`;
        else if (val === '2') url = `/queries/readers-by-work-on-hands?work_id=${getVal('workId')}`;
        else if (val === '3') url = `/queries/readers-by-publication-on-hands?publication_id=${getVal('pubId')}`;
        else if (val === '4') url = `/queries/readers-by-work-in-period?work_id=${getVal('workId')}&date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '5') url = `/queries/publications-from-own-library?reader_id=${getVal('readerId')}&date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '6') url = `/queries/publications-from-other-library?reader_id=${getVal('readerId')}&date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '7') url = `/queries/loaned-from-shelf?shelf_id=${getVal('shelfId')}`;
        else if (val === '8') url = `/queries/readers-served-by-employee?employee_id=${getVal('empId')}&date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '9') url = `/queries/employee-workload?date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '10') url = `/queries/readers-with-overdue`;
        else if (val === '11') url = `/queries/copy-movements?date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '12') url = `/queries/employees-by-reading-room?library_id=${getVal('libId')}&reading_room_id=${getVal('roomId')}`;
        else if (val === '13') url = `/queries/inactive-readers?date_from=${getVal('dateFrom')}&date_to=${getVal('dateTo')}`;
        else if (val === '14') url = `/queries/copies-by-work?work_id=${getVal('workId')}`;
        else if (val === '15') url = `/queries/copies-by-author?author_id=${getVal('authorId')}`;
        else if (val === '16') url = `/queries/popular-works`;
        try {
            const data = await apiRequest(url);
            document.getElementById('queryResult').innerHTML = '<pre>' + JSON.stringify(data, null, 2) + '</pre>';
        } catch(e) { alert('Ошибка: ' + e.message); }
    };
}

// ----- РАЗДЕЛ ЧИТАТЕЛЯ -----
async function renderMyLoans() {
    if (!currentReaderId) {
        document.getElementById('content').innerHTML = '<div class="card"><div class="card-body">Не удалось определить ваш reader_id. Обратитесь к библиотекарю.</div></div>';
        return;
    }
    const content = document.getElementById('content');
    content.innerHTML = `<div class="card"><div class="card-header">Мои книги</div><div class="card-body"><div id="myLoansList">Загрузка...</div></div></div>`;
    try {
        const loans = await apiRequest(`/loans/reader/${currentReaderId}`);
        const container = document.getElementById('myLoansList');
        if (loans.length === 0) container.innerHTML = '<p>У вас нет выданных книг</p>';
        else container.innerHTML = loans.map(l => `<div>Инв.№ ${l.copy_inventory_number} – выдана ${l.date_of_issue}, вернуть до ${l.expire_date}${l.return_date ? ' (возвращена)' : ''}</div>`).join('');
    } catch(e) { document.getElementById('myLoansList').innerHTML = '<p>Ошибка загрузки</p>'; }
}

async function renderSearch() {
    const content = document.getElementById('content');
    content.innerHTML = `
        <div class="card"><div class="card-header">Поиск книг по названию</div><div class="card-body">
            <input id="searchQuery" class="form-control mb-2" placeholder="Название или часть">
            <button id="searchBtn" class="btn btn-primary">Искать</button>
            <div id="searchResults"></div>
        </div></div>`;
    document.getElementById('searchBtn').onclick = async () => {
        const query = document.getElementById('searchQuery').value.toLowerCase();
        if (!query) return;
        try {
            const pubs = await apiRequest('/publications');
            const filtered = pubs.filter(p => p.title.toLowerCase().includes(query));
            const container = document.getElementById('searchResults');
            if (filtered.length === 0) container.innerHTML = '<p>Ничего не найдено</p>';
            else container.innerHTML = filtered.map(p => `<div>${p.title} (${p.publisher}, ${p.publish_date})</div>`).join('');
        } catch(e) { alert('Ошибка поиска'); }
    };
}

// ----- АУТЕНТИФИКАЦИЯ -----
document.addEventListener('DOMContentLoaded', () => {
    // Регистрация
    const registerBtn = document.getElementById('registerBtn');
    if (registerBtn) {
        registerBtn.onclick = async () => {
            const login = document.getElementById('regLogin').value.trim();
            const password = document.getElementById('regPassword').value;
            const roleSel = document.getElementById('regRole').value;
            if (!login || !password) { alert('Заполните логин и пароль'); return; }
            try {
                const response = await fetch(API_BASE + '/register', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ login, password, role: roleSel })
                });
                if (!response.ok) {
                    const errText = await response.text();
                    throw new Error(errText);
                }
                alert('Регистрация успешна! Теперь войдите.');
                const loginTab = new bootstrap.Tab(document.getElementById('login-tab'));
                loginTab.show();
                document.getElementById('regLogin').value = '';
                document.getElementById('regPassword').value = '';
                document.getElementById('registerError').innerHTML = '';
            } catch (err) {
                document.getElementById('registerError').innerHTML = err.message;
            }
        };
    }

    // Логин
    const loginBtn = document.getElementById('loginBtn');
    if (loginBtn) {
        loginBtn.onclick = async () => {
            const login = document.getElementById('login').value.trim();
            const password = document.getElementById('password').value;
            if (!login || !password) { alert('Введите логин и пароль'); return; }
            try {
                const resp = await fetch(API_BASE + '/login', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ login, password })
                });
                if (!resp.ok) throw new Error('Неверный логин или пароль');
                const data = await resp.json();
                token = data.token;
                role = data.role;
                if (data.reader_id) currentReaderId = data.reader_id;
                if (data.employee_id) currentEmployeeId = data.employee_id;
                localStorage.setItem('token', token);
                localStorage.setItem('role', role);
                localStorage.setItem('currentReaderId', currentReaderId || '');
                localStorage.setItem('currentEmployeeId', currentEmployeeId || '');
                document.getElementById('loginForm').style.display = 'none';
                document.getElementById('app').style.display = 'block';
                renderNav();
            } catch (err) {
                document.getElementById('loginError').innerText = err.message;
            }
        };
    }

    // Выход
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.onclick = () => {
            localStorage.removeItem('token');
            localStorage.removeItem('role');
            localStorage.removeItem('currentReaderId');
            localStorage.removeItem('currentEmployeeId');
            token = null;
            role = null;
            currentReaderId = null;
            currentEmployeeId = null;
            document.getElementById('loginForm').style.display = 'block';
            document.getElementById('app').style.display = 'none';
        };
    }

    // Восстановление сессии
    const savedToken = localStorage.getItem('token');
    const savedRole = localStorage.getItem('role');
    if (savedToken && savedRole) {
        token = savedToken;
        role = savedRole;
        currentReaderId = localStorage.getItem('currentReaderId') || null;
        currentEmployeeId = localStorage.getItem('currentEmployeeId') || null;
        document.getElementById('loginForm').style.display = 'none';
        document.getElementById('app').style.display = 'block';
        renderNav();
    }
});