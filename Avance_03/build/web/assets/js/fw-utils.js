/**
 * FastWheels - Utilidades JavaScript
 * Loading spinners, validación client-side, dark mode y más
 */

// ============================================================================
// LOADING SPINNERS
// ============================================================================

const FWLoader = {
    overlay: null,

    init() {
        if (this.overlay) return;

        this.overlay = document.createElement('div');
        this.overlay.id = 'fw-loading-overlay';
        this.overlay.innerHTML = `
            <div class="fw-spinner-container">
                <div class="fw-spinner"></div>
                <p class="fw-loading-text">Cargando...</p>
            </div>
        `;
        this.overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        `;
        document.body.appendChild(this.overlay);

        if (!document.getElementById('fw-loader-styles')) {
            const style = document.createElement('style');
            style.id = 'fw-loader-styles';
            style.textContent = `
                .fw-spinner-container { text-align: center; }
                .fw-spinner {
                    width: 50px;
                    height: 50px;
                    border: 4px solid rgba(255, 255, 255, 0.3);
                    border-top-color: #667eea;
                    border-radius: 50%;
                    animation: fw-spin 0.8s linear infinite;
                    margin: 0 auto 15px;
                }
                .fw-loading-text {
                    color: white;
                    font-family: 'Inter', sans-serif;
                    font-size: 14px;
                    font-weight: 500;
                }
                @keyframes fw-spin { to { transform: rotate(360deg); } }
                
                .btn-loading {
                    position: relative;
                    pointer-events: none;
                    opacity: 0.8;
                }
                .btn-loading::after {
                    content: '';
                    position: absolute;
                    width: 16px;
                    height: 16px;
                    top: 50%;
                    left: 50%;
                    margin-left: -8px;
                    margin-top: -8px;
                    border: 2px solid currentColor;
                    border-top-color: transparent;
                    border-radius: 50%;
                    animation: fw-spin 0.6s linear infinite;
                }
                .btn-loading .btn-text { visibility: hidden; }
            `;
            document.head.appendChild(style);
        }
    },

    show(message = 'Cargando...') {
        this.init();
        this.overlay.querySelector('.fw-loading-text').textContent = message;
        this.overlay.style.display = 'flex';
    },

    hide() {
        if (this.overlay) {
            this.overlay.style.display = 'none';
        }
    },

    buttonLoading(button, loading = true) {
        if (loading) {
            button.classList.add('btn-loading');
            button.disabled = true;
        } else {
            button.classList.remove('btn-loading');
            button.disabled = false;
        }
    }
};

// ============================================================================
// VALIDACIÓN CLIENT-SIDE
// ============================================================================

const FWValidation = {
    patterns: {
        email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        dni: /^\d{8}$/,
        telefono: /^\d{9}$/,
        password: /^.{6,}$/,
        matricula: /^[A-Z]{3}-\d{3}$|^[A-Z0-9]{6,7}$/i
    },

    messages: {
        required: 'Este campo es obligatorio',
        email: 'Ingresa un email válido',
        dni: 'El DNI debe tener 8 dígitos',
        telefono: 'El teléfono debe tener 9 dígitos',
        password: 'La contraseña debe tener mínimo 6 caracteres',
        passwordMatch: 'Las contraseñas no coinciden',
        matricula: 'Formato de matrícula inválido'
    },

    validateField(input, rules = []) {
        const value = input.value.trim();
        let isValid = true;
        let errorMessage = '';

        for (const rule of rules) {
            if (rule === 'required' && !value) {
                isValid = false;
                errorMessage = this.messages.required;
                break;
            }

            if (value && this.patterns[rule] && !this.patterns[rule].test(value)) {
                isValid = false;
                errorMessage = this.messages[rule];
                break;
            }
        }

        this.showFieldState(input, isValid, errorMessage);
        return isValid;
    },

    showFieldState(input, isValid, message = '') {
        input.classList.remove('is-valid', 'is-invalid');

        let feedback = input.parentElement.querySelector('.invalid-feedback');
        if (!feedback) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            input.parentElement.appendChild(feedback);
        }

        if (isValid) {
            input.classList.add('is-valid');
            feedback.textContent = '';
        } else {
            input.classList.add('is-invalid');
            feedback.textContent = message;
            feedback.style.display = 'block';
        }
    },

    validateForm(form, config) {
        let isValid = true;
        for (const [fieldName, rules] of Object.entries(config)) {
            const input = form.querySelector(`[name="${fieldName}"]`);
            if (input && !this.validateField(input, rules)) {
                isValid = false;
            }
        }
        return isValid;
    },

    initRealTimeValidation(form, config) {
        for (const [fieldName, rules] of Object.entries(config)) {
            const input = form.querySelector(`[name="${fieldName}"]`);
            if (input) {
                input.addEventListener('blur', () => this.validateField(input, rules));
                input.addEventListener('input', () => {
                    if (input.classList.contains('is-invalid')) {
                        this.validateField(input, rules);
                    }
                });
            }
        }
    }
};

// ============================================================================
// DARK MODE
// ============================================================================

const FWDarkMode = {
    storageKey: 'fw-dark-mode',

    init() {
        this.injectStyles();

        const savedPreference = localStorage.getItem(this.storageKey);
        if (savedPreference !== null) {
            this.setMode(savedPreference === 'true');
        } else if (window.matchMedia('(prefers-color-scheme: dark)').matches) {
            this.setMode(true);
        }

        this.createToggleButton();
    },

    injectStyles() {
        if (document.getElementById('fw-dark-mode-styles')) return;

        const style = document.createElement('style');
        style.id = 'fw-dark-mode-styles';
        style.textContent = `
            .dark-mode-toggle {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                border: none;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-size: 20px;
                cursor: pointer;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                z-index: 1000;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .dark-mode-toggle:hover {
                transform: scale(1.1);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
            }
            
            body.dark-mode {
                --bg-primary: #0f172a;
                --bg-secondary: #1e293b;
                --bg-card: #1e293b;
                --text-primary: #f1f5f9;
                --text-secondary: #94a3b8;
                --border-color: #334155;
            }
            
            body.dark-mode { background-color: var(--bg-primary) !important; color: var(--text-primary); }
            body.dark-mode .main-content { background-color: var(--bg-primary) !important; }
            body.dark-mode .card, body.dark-mode .stat-card, body.dark-mode .filter-card,
            body.dark-mode .table-card, body.dark-mode .card-filter, body.dark-mode .card-table {
                background-color: var(--bg-card) !important;
                border-color: var(--border-color) !important;
            }
            body.dark-mode .table thead th {
                background-color: var(--bg-secondary) !important;
                color: var(--text-secondary) !important;
                border-color: var(--border-color) !important;
            }
            body.dark-mode .table tbody td { border-color: var(--border-color) !important; color: var(--text-primary) !important; }
            body.dark-mode .table tbody tr:hover { background-color: #334155 !important; }
            body.dark-mode .form-control, body.dark-mode .form-select {
                background-color: var(--bg-secondary) !important;
                border-color: var(--border-color) !important;
                color: var(--text-primary) !important;
            }
            body.dark-mode .form-control::placeholder { color: var(--text-secondary) !important; }
            body.dark-mode .text-dark { color: var(--text-primary) !important; }
            body.dark-mode .text-muted { color: var(--text-secondary) !important; }
            body.dark-mode .btn-light {
                background-color: var(--bg-secondary) !important;
                border-color: var(--border-color) !important;
                color: var(--text-primary) !important;
            }
            body.dark-mode .card-footer, body.dark-mode .card-header {
                background-color: var(--bg-card) !important;
                border-color: var(--border-color) !important;
            }
            body.dark-mode .dropdown-menu {
                background-color: var(--bg-card) !important;
                border-color: var(--border-color) !important;
            }
            body.dark-mode .dropdown-item { color: var(--text-primary) !important; }
            body.dark-mode .dropdown-item:hover { background-color: var(--bg-secondary) !important; }
            body.dark-mode .alert { background-color: var(--bg-secondary) !important; border-color: var(--border-color) !important; }
            body.dark-mode .pagination-custom .page-link { background-color: transparent; color: var(--text-secondary); }
            body.dark-mode .pagination-custom .page-link:hover { background-color: var(--bg-secondary); }
            body.dark-mode .input-group-text {
                background-color: var(--bg-secondary) !important;
                border-color: var(--border-color) !important;
                color: var(--text-secondary) !important;
            }
        `;
        document.head.appendChild(style);
    },

    createToggleButton() {
        if (document.querySelector('.dark-mode-toggle')) return;

        const button = document.createElement('button');
        button.className = 'dark-mode-toggle';
        button.setAttribute('aria-label', 'Toggle dark mode');
        button.setAttribute('title', 'Cambiar tema');
        button.innerHTML = '<i class="fas fa-moon"></i>';

        button.addEventListener('click', () => this.toggle());

        document.body.appendChild(button);
        this.updateIcon();
    },

    setMode(isDark) {
        if (isDark) {
            document.body.classList.add('dark-mode');
        } else {
            document.body.classList.remove('dark-mode');
        }
        localStorage.setItem(this.storageKey, isDark);
        this.updateIcon();
    },

    toggle() {
        const isDark = document.body.classList.contains('dark-mode');
        this.setMode(!isDark);
    },

    updateIcon() {
        const button = document.querySelector('.dark-mode-toggle');
        if (button) {
            const isDark = document.body.classList.contains('dark-mode');
            button.innerHTML = isDark ? '<i class="fas fa-sun"></i>' : '<i class="fas fa-moon"></i>';
        }
    },

    isDarkMode() {
        return document.body.classList.contains('dark-mode');
    }
};

// ============================================================================
// TOAST NOTIFICATIONS
// ============================================================================

const FWToast = {
    container: null,

    init() {
        if (this.container) return;

        this.container = document.createElement('div');
        this.container.id = 'fw-toast-container';
        this.container.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: flex;
            flex-direction: column;
            gap: 10px;
        `;
        document.body.appendChild(this.container);

        if (!document.getElementById('fw-toast-styles')) {
            const style = document.createElement('style');
            style.id = 'fw-toast-styles';
            style.textContent = `
                .fw-toast {
                    padding: 16px 20px;
                    border-radius: 12px;
                    color: white;
                    font-family: 'Inter', sans-serif;
                    font-size: 14px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                    animation: fw-toast-in 0.3s ease;
                    min-width: 300px;
                    max-width: 400px;
                }
                .fw-toast.success { background: linear-gradient(135deg, #059669, #10b981); }
                .fw-toast.error { background: linear-gradient(135deg, #dc2626, #ef4444); }
                .fw-toast.warning { background: linear-gradient(135deg, #d97706, #f59e0b); }
                .fw-toast.info { background: linear-gradient(135deg, #667eea, #764ba2); }
                
                .fw-toast-close {
                    margin-left: auto;
                    background: none;
                    border: none;
                    color: white;
                    opacity: 0.7;
                    cursor: pointer;
                    font-size: 18px;
                    padding: 0;
                }
                .fw-toast-close:hover { opacity: 1; }
                
                @keyframes fw-toast-in {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
                @keyframes fw-toast-out {
                    from { transform: translateX(0); opacity: 1; }
                    to { transform: translateX(100%); opacity: 0; }
                }
            `;
            document.head.appendChild(style);
        }
    },

    show(message, type = 'info', duration = 4000) {
        this.init();

        const icons = {
            success: 'fas fa-check-circle',
            error: 'fas fa-exclamation-circle',
            warning: 'fas fa-exclamation-triangle',
            info: 'fas fa-info-circle'
        };

        const toast = document.createElement('div');
        toast.className = `fw-toast ${type}`;
        toast.innerHTML = `
            <i class="${icons[type]}"></i>
            <span>${message}</span>
            <button class="fw-toast-close">&times;</button>
        `;

        this.container.appendChild(toast);

        toast.querySelector('.fw-toast-close').addEventListener('click', () => {
            this.dismiss(toast);
        });

        if (duration > 0) {
            setTimeout(() => this.dismiss(toast), duration);
        }

        return toast;
    },

    dismiss(toast) {
        toast.style.animation = 'fw-toast-out 0.3s ease forwards';
        setTimeout(() => toast.remove(), 300);
    },

    success(message, duration) { return this.show(message, 'success', duration); },
    error(message, duration) { return this.show(message, 'error', duration); },
    warning(message, duration) { return this.show(message, 'warning', duration); },
    info(message, duration) { return this.show(message, 'info', duration); }
};

// ============================================================================
// INICIALIZACIÓN AUTOMÁTICA
// ============================================================================

function initFWUtils() {
    console.log('🚀 FW Utils: Inicializando...');

    FWDarkMode.init();
    console.log('🌙 Dark Mode: Inicializado');

    FWLoader.init();
    console.log('⏳ Loader: Inicializado');

    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', function (e) {
            const submitBtn = form.querySelector('[type="submit"]');
            if (submitBtn && !form.dataset.noLoading) {
                FWLoader.buttonLoading(submitBtn, true);
            }
        });
    });

    document.querySelectorAll('form[data-validate]').forEach(form => {
        const config = JSON.parse(form.dataset.validate || '{}');
        FWValidation.initRealTimeValidation(form, config);

        form.addEventListener('submit', function (e) {
            if (!FWValidation.validateForm(form, config)) {
                e.preventDefault();
                FWToast.error('Por favor, corrige los errores en el formulario');
            }
        });
    });

    console.log('✅ FW Utils: Listo');
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFWUtils);
} else {
    initFWUtils();
}

window.FWLoader = FWLoader;
window.FWValidation = FWValidation;
window.FWDarkMode = FWDarkMode;
window.FWToast = FWToast;
