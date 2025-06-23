# Приложение для мониторинга умного дома

## Описание

Демонстрационное iOS-приложение для портфолио. Позволяет авторизоваться, просматривать список устройств умного дома, смотреть телеметрию (температура, влажность, CO₂, энергопотребление) с графиками и деталями по каждому устройству. Все данные — моковые, без реального бэкенда. Есть экран статистики ScreenTime (время использования приложения за сегодня).

## Стек технологий
- **UIKit**
- **MVVM** + Coordinator
- **SnapKit**
- **SDWebImage** (загрузка и кеширование картинок)
- **DGCharts** (графики)
- **Resolver** (Dependency Injection)
- **Combine** (реактивность)
- **ScreenTime API** (DeviceActivityReport, iOS 16+)
- Минимальная версия iOS: **16.6**

## Архитектура
- MVVM + Coordinator
- DI через Resolver (только для сервисов)
- Моковые сервисы для тестирования и быстрой разработки

## Скриншоты
<img width="200" alt="Экран авторизации" src="https://github.com/user-attachments/assets/7871dfae-42de-47ce-87bd-a64a8be7507c"/>

<img width="200" alt="Главный экран с устройствами" src="https://github.com/user-attachments/assets/39592fa3-259c-4628-a1a1-896ff13c5cbb" />

<img width="200" alt="Экран устройства" src="https://github.com/user-attachments/assets/dfe7b1d9-2ded-4f36-9ec7-e4b1ef8bf07b" />

<img width="200" alt="Экран со статистикой" src="https://github.com/user-attachments/assets/2ff8f526-e5d5-46e5-8b0a-3a0f566c3f10" />


## Структура проекта

- Coordinators         // Координаторы навигации
- DI                   // DI-контейнер Resolver
- Models               // Модели данных (Device, User, Telemetry)
- Modules              // Модули (экраны): Auth, Home, DeviceDetails, Settings, Statistics
- Services             // Сервисы (MockAuthService, MockDeviceService и др.)
- Views                // View/Cell
- Common               // Константы, утилиты

## Как запустить
1. Откройте проект в **Xcode 15+**.
2. Убедитесь, что выбран target **iOS 16.6** или выше.
3. Сборка и запуск (`Cmd+R`).
4. При первом запуске появится окно авторизации.

### Тестовые данные для входа
- **Email:** `test@test.com`
- **Пароль:** `123456`

## Особенности работы ScreenTime
- На **симуляторе** всегда отображаются тестовые (моковые) данные.
- На **реальном устройстве** (iOS 16+) используется реальный ScreenTime API (DeviceActivityReport).
- При первом запуске на устройстве потребуется разрешение пользователя на доступ к статистике ScreenTime.
- Если разрешение не дано или статистика недоступна — отображается соответствующее сообщение.


