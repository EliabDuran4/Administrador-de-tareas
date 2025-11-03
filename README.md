# 📋 Flutter Task Manager

Aplicación móvil desarrollada en **Flutter** que permite gestionar tus tareas de manera sencilla e intuitiva.  
Cuenta con recordatorios configurables para no olvidar ninguna actividad importante.  

---

## 🚀 Características principales

✅ Agregar, editar y eliminar tareas fácilmente.  
⏰ Establecer **recordatorios** con fecha y hora.  
💾 Almacenamiento local con **Shared Preferences**.  
🎨 Interfaz moderna con colores dinámicos y diseño minimalista.  
🌓 Modo claro y oscuro (opcional para futuras versiones).  

---

## 🖼️ Capturas de pantalla

| Pantalla principal | Agregar tarea | Recordatorio |
|:------------------:|:--------------:|:--------------:|
| ![Home](assets/screenshots/home.png) | ![Add](assets/screenshots/add.png) | ![Reminder](assets/screenshots/reminder.png) |

*(Puedes agregar tus capturas de pantalla en la carpeta `assets/screenshots/` y actualizar las rutas.)*

---

## 🛠️ Tecnologías utilizadas

- **Flutter 3.x**  
- **Dart**  
- **Local Notifications**  
- **Shared Preferences**  
- **Material Design 3**

---

## 🧩 Estructura del proyecto

lib/
├── main.dart
├── screens/
│ ├── home_screen.dart
│ └── task_form.dart
├── models/
│ └── task_model.dart
├── services/
│ └── task_service.dart
└── utils/
└── notification_service.dart

---

## ⚙️ Instalación y ejecución

Sigue estos pasos para probar el proyecto localmente 👇

```bash
# Clonar el repositorio
git clone https://github.com/tu_usuario/flutter_task_manager.git

# Entrar al directorio
cd flutter_task_manager

# Instalar dependencias
flutter pub get

# Ejecutar en un emulador o dispositivo físico
flutter run
Aprendizajes

Durante el desarrollo de esta app aprendí a:

Implementar persistencia de datos local.

Manejar estado en Flutter con setState y FutureBuilder.

Integrar notificaciones locales programadas.

Aplicar principios de diseño UI/UX en Flutter.

🌟 Próximas mejoras

 Editar tareas existentes.

 Integrar modo oscuro.

 Sincronizar con Firebase o una base de datos en la nube.

 Notificaciones repetitivas (diarias/semanales).

👨‍💻 Autor

Eliab Durán
📍 Desarrollador en formación apasionado por Flutter y las interfaces modernas.