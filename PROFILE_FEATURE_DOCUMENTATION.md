# Profile Feature Documentation

## Overview

The Profile feature allows users to create, view, edit, and manage their personal information in the Animeverse app. The feature is built using Clean Architecture with Supabase as the backend database.

## Profile Fields

The profile includes the following fields:
- **First Name**: User's first name (required)
- **Last Name**: User's last name (required)
- **Street**: Street address (required)
- **ZIP**: ZIP/postal code (required, string format to support international codes)
- **State**: State/province (required)
- **Phone**: Phone number (required, supports international formats)

## Database Setup

### 1. Run the Supabase SQL Script

Execute the SQL script `supabase_profiles_setup.sql` in your Supabase project's SQL editor:

```sql
-- This script creates the profiles table with:
-- - Proper foreign key relationship to auth.users
-- - Row Level Security (RLS) policies
-- - Automatic timestamp updates
-- - Indexes for performance
```

### 2. Verify Table Creation

After running the script, verify that:
- The `profiles` table exists
- RLS is enabled
- The policies are created correctly
- The trigger for `updated_at` is working

## Architecture

The profile feature follows Clean Architecture principles:

```
lib/features/profile/
├── data/
│   ├── datasources/
│   │   └── profile_remote_datasource_impl.dart
│   ├── models/
│   │   └── profile_model.dart
│   └── repositories/
│       └── profile_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── profile_entity.dart
│   ├── repositories/
│   │   └── profile_repository.dart
│   └── usecases/
│       ├── get_profile_usecase.dart
│       ├── create_profile_usecase.dart
│       └── update_profile_usecase.dart
└── presentation/
    ├── providers/
    │   └── profile_provider.dart
    ├── screens/
    │   └── profile_screen.dart
    └── widgets/
        ├── profile_display.dart
        └── profile_form.dart
```

## Usage

### Accessing the Profile Screen

The profile screen is accessible through:
1. **Bottom Navigation**: The profile tab in the main screen
2. **Direct Navigation**: Using `GoRouter.of(context).pushNamed(AppRouteName.profile)`

### Profile States

The profile screen handles three main states:

1. **Loading State**: Shows a circular progress indicator
2. **Error State**: Shows error message with retry button
3. **Profile States**:
   - **No Profile**: Shows create profile form
   - **View Mode**: Shows profile information with edit button
   - **Edit Mode**: Shows editable form with save/cancel buttons

### Profile Operations

#### Create Profile
- Automatically triggered for new users with no existing profile
- Requires all fields to be filled
- Uses the current user's ID from Supabase auth

#### View Profile
- Displays user information in a card-based layout
- Shows welcome message with user's initials
- Organized into sections (Personal Info, Address, Contact)

#### Edit Profile
- Toggle edit mode with the edit button
- Form validation for all required fields
- Phone number validation with international format support
- ZIP code validation (minimum 5 characters)

## Dependencies

The profile feature relies on:

- **Supabase**: Backend database and authentication
- **flutter_riverpod**: State management
- **dartz**: Functional programming (Either type)
- **equatable**: Value equality
- **get_it**: Dependency injection

## Security

- **Row Level Security (RLS)**: Users can only access their own profile
- **Authentication Required**: All operations require authenticated user
- **Data Validation**: Both client-side and server-side validation

## Error Handling

The feature handles various error scenarios:

- **Network Errors**: Connectivity issues with Supabase
- **Authentication Errors**: User not logged in
- **Validation Errors**: Invalid form data
- **Database Errors**: Supabase operation failures

## Customization

### Adding New Fields

To add new fields to the profile:

1. Update `ProfileEntity` in `profile_entity.dart`
2. Update `ProfileModel` in `profile_model.dart`
3. Update the Supabase table schema
4. Update the form widgets to include new fields
5. Update validation logic if needed

### Styling

The UI uses Material Design 3 components and follows the app's theme:
- Cards for grouping information
- Icons for visual identification
- Consistent spacing and typography
- Responsive layout

## Testing

To test the profile feature:

1. **Create Profile**: Register a new user and verify profile creation
2. **View Profile**: Ensure all fields display correctly
3. **Edit Profile**: Test form validation and save functionality
4. **Error Handling**: Test with network issues and invalid data
5. **Navigation**: Verify proper routing and state management

## Troubleshooting

### Common Issues

1. **Profile Not Loading**
   - Check Supabase connection
   - Verify user authentication
   - Check RLS policies

2. **Save Operation Fails**
   - Verify form validation
   - Check network connectivity
   - Review Supabase logs

3. **Navigation Issues**
   - Ensure proper route configuration
   - Check dependency injection setup

### Debug Tips

- Use Flutter DevTools to inspect state changes
- Check Supabase dashboard for database operations
- Review console logs for error messages
- Verify API responses in network inspector