# Profile Feature

This feature handles the profile completion flow after user verification. It guides users through creating their profile with a focus on building meaningful connections.

## Overview

The profile completion flow consists of three main pages that collect essential information about the user:

1. **Profile Completion Intro** - Welcome screen with visual introduction
2. **Profile Bio** - Personal introduction and self-description
3. **Profile Interests** - Interest selection across multiple categories

## Flow Architecture

```
Verification Complete
       ↓
Profile Completion Intro
       ↓
Profile Bio (15% progress)
       ↓
Profile Interests (30% progress)
       ↓
Home Screen
```

## Pages

### 1. ProfileCompletionIntroPage

**Purpose**: Welcome users to the profile completion process with an engaging visual introduction.

**Key Features**:
- Full-screen couple image with gradient overlay
- Gradient overlay from chin down (5 stops: transparent → 0.85 opacity black)
- Welcome message with app branding
- Clear call-to-action button
- Smooth transition to bio page

**Design Elements**:
- Image: `assets/images/couple_intro.jpg`
- Gradient: 5-stop linear gradient (top to bottom)
  - Stop 1: Transparent (0.0)
  - Stop 2: Transparent (0.5)
  - Stop 3: Black 30% opacity (0.65)
  - Stop 4: Black 70% opacity (0.85)
  - Stop 5: Black 85% opacity (1.0)
- Button: Green (#2CA97B) with 28px border radius
- Font: Delight family

**Navigation**:
- Entry: From verification complete page
- Exit: To profile bio page
- Route: `/profile-intro`

### 2. ProfileBioPage

**Purpose**: Allow users to write a personal introduction that showcases their personality.

**Key Features**:
- Progress indicator (15%)
- Multi-line text input (6 lines visible)
- Character counter (300 character limit)
- Real-time character validation
- Italic placeholder text for guidance
- Skip option for optional completion
- Continue button with validation

**Design Elements**:
- Progress bar: Green (#2CA97B) at 15%
- Text area: 6 lines, bordered with 28px radius
- Character limit: 300 characters
- Placeholder: Italic style for example text
- Button: Full-width green with 28px radius

**Validation**:
- Minimum: No minimum (can skip)
- Maximum: 300 characters
- Real-time counter display
- Visual feedback on character limit

**Navigation**:
- Entry: From profile intro page
- Exit: To profile interests page (or skip)
- Route: `/profile-bio`

### 3. ProfileInterestsPage

**Purpose**: Help users select interests that represent their personality and lifestyle preferences.

**Key Features**:
- Progress indicator (30%)
- 6 expandable categories
- 46 total interest options
- Maximum 10 selections
- Visual selection feedback
- Category icons for quick identification
- Floating action button with counter
- SnackBar validation messages

**Categories & Interests**:

1. **Hobbies & Interests** (8 options)
   - Icon: palette_outlined
   - Reading, Traveling, Cooking, Photography, Music, Sports, Gaming, Art & Crafts

2. **Education** (7 options)
   - Icon: school_outlined
   - High School, Bachelor's Degree, Master's Degree, PhD, Vocational Training, Self-taught, Currently Studying

3. **Work-Life Balance** (7 options)
   - Icon: work_outline
   - Career-focused, Work-life balance, Entrepreneur, Freelancer, Remote work, Traditional office, Flexible schedule

4. **Parenthood** (6 options)
   - Icon: family_restroom_outlined
   - Want children, Don't want children, Have children, Open to children, Not sure yet, Prefer not to say

5. **Personality & Values** (10 options)
   - Icon: favorite_outline
   - Adventurous, Homebody, Social butterfly, Introverted, Spontaneous, Planner, Optimistic, Realistic, Spiritual, Intellectual

6. **Pets** (7 options)
   - Icon: pets_outlined
   - Dog lover, Cat lover, Have pets, Don't have pets, Want pets, Allergic to pets, Other pets

**Design Elements**:
- Progress bar: Green (#2CA97B) at 30%
- Category cards: White background, bordered, 28px radius
- Expand/collapse: Smooth animation with arrow icon
- Interest chips: FilterChip with custom styling
- Selected state: Green tint, border, and checkmark
- Unselected state: Grey background
- FAB: Extended with counter display

**Validation**:
- Minimum: 1 interest required
- Maximum: 10 interests allowed
- SnackBar alerts for validation errors
- Real-time counter in FAB

**Navigation**:
- Entry: From profile bio page
- Exit: To home screen
- Route: `/profile-interests`

## Design System

### Colors
- Primary: `#2CA97B` (Green)
- Background: `#FFFFFF` (White)
- Text Primary: `#000000` (Black)
- Text Secondary: `#757575` (Grey 600)
- Border: `#E0E0E0` (Grey 300)
- Disabled: `#BDBDBD` (Grey 400)

### Typography
- Font Family: Delight
- Title: 32px, Bold
- Subtitle: 16px, Regular
- Body: 14-16px, Regular
- Button: 16px, SemiBold

### Spacing
- Page padding: 24px horizontal
- Section spacing: 24px vertical
- Element spacing: 8-16px
- Border radius: 28px (all rounded elements)

### Components
- Buttons: Full-width, 28px radius, 56px height
- Text fields: Bordered, 28px radius, multi-line support
- Progress bar: 8px height, 28px radius, green fill
- Cards: White, bordered, 28px radius
- Chips: 28px radius, padding 16px horizontal, 8px vertical

## State Management

Currently using StatefulWidget for local state management. Future considerations:

- **BLoC Pattern**: For complex state management
- **Provider**: For dependency injection
- **Form Validation**: Dedicated validation logic
- **Data Persistence**: Save progress to backend/local storage

## Data Models

### ProfileBio
```dart
class ProfileBio {
  final String bio;
  final DateTime createdAt;
}
```

### ProfileInterests
```dart
class ProfileInterests {
  final List<String> selectedInterests;
  final DateTime createdAt;
}
```

## TODO

### High Priority
- [ ] Integrate with backend API for data persistence
- [ ] Add form validation with proper error handling
- [ ] Implement data models and repositories
- [ ] Add loading states during API calls
- [ ] Handle navigation state restoration
- [ ] Add analytics tracking for user progress

### Medium Priority
- [ ] Add animation transitions between pages
- [ ] Implement profile preview page
- [ ] Add edit functionality for completed profiles
- [ ] Support for profile photo upload
- [ ] Localization support (i18n)
- [ ] Accessibility improvements

### Low Priority
- [ ] Add tutorial/onboarding tooltips
- [ ] Custom interest creation
- [ ] Interest recommendations based on selections
- [ ] Social proof (show popular interests)
- [ ] A/B testing different copy variations

## Testing

### Unit Tests
- [ ] Test interest selection logic
- [ ] Test character counting in bio
- [ ] Test validation rules
- [ ] Test state management

### Widget Tests
- [ ] Test page rendering
- [ ] Test user interactions
- [ ] Test navigation flow
- [ ] Test form validation UI

### Integration Tests
- [ ] Test complete profile flow
- [ ] Test data persistence
- [ ] Test error handling
- [ ] Test navigation edge cases

## File Structure

```
lib/features/profile/
├── presentation/
│   └── pages/
│       ├── profile_completion_intro_page.dart
│       ├── profile_bio_page.dart
│       ├── profile_interests_page.dart
│       └── pages.dart (exports)
├── domain/
│   └── (future: entities, repositories)
├── data/
│   └── (future: models, data sources)
└── README.md (this file)
```

## Related Features

- **Verification**: Entry point to profile completion
- **Authentication**: User identity for profile data
- **Home**: Destination after profile completion
- **Settings**: Future profile editing functionality

## Resources

- Design Files: See PROFILE_COMPLETION_IMPLEMENTATION.md
- API Documentation: TBD
- User Research: TBD
