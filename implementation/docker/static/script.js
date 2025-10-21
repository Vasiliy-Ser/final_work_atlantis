// Инициализация при загрузке страницы
document.addEventListener('DOMContentLoaded', function() {
    updateDateTime();
    updateHostname();
    animateElements();
    checkImageStatus();
    
    // Обновляем время каждую секунду
    setInterval(updateDateTime, 1000);
});

function updateDateTime() {
    const now = new Date();
    document.getElementById('current-time').textContent = 
        now.toLocaleString('ru-RU', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
}

function updateHostname() {
    document.getElementById('hostname').textContent = window.location.hostname;
}

function animateElements() {
    const elements = document.querySelectorAll('.container > *');
    elements.forEach((el, index) => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(20px)';
        setTimeout(() => {
            el.style.transition = 'all 0.6s ease';
            el.style.opacity = '1';
            el.style.transform = 'translateY(0)';
        }, index * 200);
    });
}

// Проверка статуса картинки
function checkImageStatus() {
    const img = new Image();
    const startTime = Date.now();
    
    img.onload = function() {
        const loadTime = Date.now() - startTime;
        const size = this.naturalWidth + 'x' + this.naturalHeight;
        
        document.getElementById('image-size').textContent = size + ' пикселей';
        document.getElementById('image-status').innerHTML = 
            '<span style="color: #27ae60;">✅ Загружена (' + loadTime + 'мс)</span>';
    };
    
    img.onerror = function() {
        document.getElementById('image-size').textContent = 'Неизвестно';
        document.getElementById('image-status').innerHTML = 
            '<span style="color: #e74c3c;">❌ Ошибка загрузки</span>';
    };
    
    img.src = 'images/sm.png?' + new Date().getTime(); // Добавляем timestamp для избежания кеширования
}

function showMessage() {
    const messages = [
        "🎉 Приложение работает отлично!",
        "⚡ Картинка sm.png успешно загружена!",
        "🐳 Docker образ успешно собран!",
        "🚀 Kubernetes управляется удаленно!",
        "📦 Все статические файлы загружены!",
        "🌐 Nginx обслуживает картинки!"
    ];
    const randomMessage = messages[Math.floor(Math.random() * messages.length)];
    
    showToast(randomMessage);
}

function showToast(message) {
    // Удаляем существующий toast
    const existingToast = document.querySelector('.toast');
    if (existingToast) {
        existingToast.remove();
    }
    
    // Создаем новый toast
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;
    toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #27ae60;
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        z-index: 1000;
        animation: slideIn 0.3s ease;
        font-weight: 500;
    `;
    
    document.body.appendChild(toast);
    
    // Удаляем toast через 3 секунды
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

function refreshData() {
    const statusCard = document.getElementById('statusCard');
    statusCard.style.opacity = '0.5';
    
    // Имитация обновления данных
    setTimeout(() => {
        const podCount = Math.floor(Math.random() * 3) + 2; // 2-4 пода
        document.getElementById('pod-count').textContent = podCount;
        
        // Перепроверяем картинку
        checkImageStatus();
        
        statusCard.style.opacity = '1';
        showToast('✅ Данные успешно обновлены!');
    }, 1000);
}

function showDeploymentInfo() {
    const info = `
Архитектура развертывания:

🏠 Хостовая машина
  ↓ (удаленное управление)
🖥 ВМ с Kubernetes
  ↓ (docker image)
🐳 Pods с Nginx
  ↓ (статичные файлы)
📄 HTML + CSS + JS
  ↓ (изображения)
🖼 Картинка sm.png
    `.trim();
    
    // Красивое отображение информации
    const modal = document.createElement('div');
    modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.8);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 1000;
        animation: fadeIn 0.3s ease;
    `;
    
    const modalContent = document.createElement('div');
    modalContent.style.cssText = `
        background: white;
        padding: 30px;
        border-radius: 15px;
        max-width: 500px;
        width: 90%;
        text-align: left;
        font-family: 'Courier New', monospace;
        white-space: pre-line;
        line-height: 1.6;
        box-shadow: 0 20px 40px rgba(0,0,0,0.3);
    `;
    
    modalContent.textContent = info;
    modal.appendChild(modalContent);
    
    modal.onclick = function() {
        modal.style.animation = 'fadeOut 0.3s ease';
        setTimeout(() => modal.remove(), 300);
    };
    
    document.body.appendChild(modal);
    
    // Добавляем CSS для анимаций модального окна
    if (!document.querySelector('#modal-styles')) {
        const style = document.createElement('style');
        style.id = 'modal-styles';
        style.textContent = `
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            @keyframes fadeOut {
                from { opacity: 1; }
                to { opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }
}