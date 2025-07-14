# Shop App - Folder Structure

This document describes the organization of the Flutter shop app's `lib` folder.

## Folder Structure

```
lib/
├── screens/                 # UI screens and pages
│   ├── splash/             # Splash screen
│   ├── auth/               # Authentication screens (login, register, etc.)
│   ├── home/               # Home screen and main navigation
│   ├── calendar/           # Calendar functionality
│   ├── schedule/           # Schedule management
│   └── shop_master/        # Shop master/admin functionality
├── widgets/                # Reusable UI components
├── services/               # Business logic and API services
├── models/                 # Data models and entities
└── utils/                  # Utility functions and constants
```

## Description

### screens/
Contains all the main screens of the application:
- **splash/**: Initial loading screen
- **auth/**: User authentication screens (login, register, forgot password)
- **home/**: Main dashboard and navigation hub
- **calendar/**: Calendar view and event management
- **schedule/**: Schedule creation and management
- **shop_master/**: Administrative functions for shop management

### widgets/
Reusable UI components that can be used across multiple screens:
- Product cards
- Custom buttons
- Form components
- Loading indicators
- etc.

### services/
Business logic and external service integrations:
- API services for backend communication
- Authentication services
- Local storage services
- Third-party integrations

### models/
Data models and entities:
- Product model
- User model
- Order model
- etc.

### utils/
Utility functions and app-wide constants:
- Constants (colors, text styles, dimensions)
- Helper functions
- Validation utilities
- Date/time utilities

## Best Practices

1. **Naming Convention**: Use snake_case for file names and camelCase for class names
2. **Single Responsibility**: Each file should have a single, well-defined purpose
3. **Separation of Concerns**: Keep UI, business logic, and data models separate
4. **Reusability**: Create reusable widgets in the widgets/ folder
5. **Consistency**: Use the constants from utils/ for consistent styling

## Getting Started

1. Start with the splash screen for app initialization
2. Implement authentication flow in auth/ folder
3. Build the main home screen with navigation
4. Add specific functionality to calendar/, schedule/, and shop_master/ folders
5. Create reusable widgets as needed
6. Implement services for data management
7. Define models for your data structures 