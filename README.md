# 📱 Social Scheduler

**Plataforma inteligente de gestión de redes sociales con IA**

Una aplicación Flutter moderna para programar, gestionar y analizar publicaciones en múltiples redes sociales desde una sola interfaz.

---

## ✨ Características

### 🎯 Funcionalidades Principales
- **📅 Calendario Inteligente**: Visualiza y gestiona todas tus publicaciones programadas
- **✍️ Editor de Posts**: Crea contenido optimizado con vista previa en tiempo real
- **🤖 Asistente IA**: Sugerencias inteligentes de contenido y optimización
- **📊 Analíticas**: Métricas detalladas de rendimiento por plataforma
- **🔄 Publicación Multi-plataforma**: Soporta Facebook, Instagram, Twitter, LinkedIn y TikTok
- **📸 Gestión de Medios**: Sube y organiza imágenes para tus publicaciones
- **🔔 Notificaciones**: Alertas de publicaciones programadas y métricas importantes

### 🎨 Diseño y UX
- **Material Design 3**: Interfaz moderna y consistente
- **Responsive Design**: Optimizado para móvil, tablet y web
- **Tema Personalizable**: Paleta de colores adaptable
- **Animaciones Fluidas**: Transiciones suaves entre pantallas

---

## 🛠️ Tecnologías

### Frontend
- **Flutter 3.35.4** - Framework multiplataforma
- **Dart 3.9.2** - Lenguaje de programación
- **Provider** - Gestión de estado
- **Material Design 3** - Sistema de diseño

### Paquetes Principales
```yaml
dependencies:
  provider: 6.1.5+1          # State management
  intl: 0.20.2               # Internacionalización
  fl_chart: 0.69.0           # Gráficas y analíticas
  image_picker: 1.1.2        # Selección de imágenes
  file_picker: 8.1.4         # Selector de archivos
  shared_preferences: 2.5.3  # Almacenamiento local
  http: 1.5.0                # Peticiones HTTP
```

---

## 🚀 Instalación y Ejecución

### Requisitos Previos
- Flutter SDK 3.35.4
- Dart SDK 3.9.2
- Android Studio / VS Code
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tu-usuario/social-scheduler-flutter.git
cd social-scheduler-flutter
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la aplicación**

**Web:**
```bash
flutter run -d chrome
```

**Android:**
```bash
flutter run -d android
```

**Compilar para producción:**
```bash
# Web
flutter build web --release

# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release
```

---

## 📂 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── models/                   # Modelos de datos
│   ├── post.dart
│   └── analytics.dart
├── screens/                  # Pantallas principales
│   ├── home_screen.dart
│   ├── calendar_screen.dart
│   ├── create_post_screen.dart
│   ├── analytics_screen.dart
│   └── profile_screen.dart
├── services/                 # Servicios y lógica
│   ├── post_service.dart
│   ├── image_picker_service.dart
│   └── storage_service.dart
└── widgets/                  # Componentes reutilizables
    ├── post_card.dart
    ├── platform_chip.dart
    └── custom_bottom_nav.dart
```

---

## 📱 Plataformas Soportadas

| Plataforma | Estado | Versión Mínima |
|-----------|--------|----------------|
| 📱 Android | ✅ Soportado | Android 6.0+ (API 23) |
| 🌐 Web | ✅ Soportado | Navegadores modernos |
| 🍎 iOS | 🚧 En desarrollo | iOS 12.0+ |
| 💻 Desktop | 🚧 Planeado | Windows/macOS/Linux |

---

## 🎯 Roadmap

### Versión Actual (1.0.0)
- ✅ Gestión básica de posts
- ✅ Calendario visual
- ✅ Selector de plataformas
- ✅ Gestión de imágenes
- ✅ Analíticas básicas

### Próximas Versiones
- 🔄 Integración con APIs de redes sociales
- 🔄 Publicación automática
- 🔄 Asistente IA para generación de contenido
- 🔄 Colaboración en equipo
- 🔄 Plantillas de posts
- 🔄 Análisis de sentimiento
- 🔄 Programación inteligente basada en mejores horarios

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -m 'Añadir nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

---

## 👨‍💻 Autor

**Diegote**  
Doctor en Sistemas de Computación | Master en IA  
Emprendedor y experto en tecnología

---

## 📞 Contacto

- 🌐 Website: [BigSeO](https://bigseo.ai)
- 📧 Email: diegote@bigseo.ai

---

## 🙏 Agradecimientos

- Flutter Team por el increíble framework
- Comunidad open-source por los paquetes utilizados
- Todos los contribuidores del proyecto

---

**⭐ Si te gusta este proyecto, dale una estrella en GitHub!**
