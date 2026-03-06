# Phase API Integration Summary

**Date:** March 5, 2026
**Task:** Implementation and integration of the Phase API (`/api/v1/phases`) into the Flutter app.

## Overview
This document summarizes the changes made to integrate the Phase API, moving from static dummy data to dynamic asynchronous API-driven data for the Phase Timelines in the app.

## Changes Implemented

### 1. Data & Domain Layers
- **Domain Entity (`lib/domain/entities/phase.dart`)**: Created the base `Phase` class using `Equatable` to represent a phase (Assess, Reset, Elevate, Sustain).
- **Data Model (`lib/data/models/phase_model.dart`)**: Created the `PhaseModel` for JSON serialization/deserialization.
- **API Constants (`lib/core/constants/app_constants.dart`)**: Added the `ApiConstants.phases` endpoint mapping.
- **API Client (`lib/data/datasources/remote/api_client.dart`)**: Added the `getPhases()` method to make the GET request to the phases endpoint and parse the `ApiResponse`.
- **Repository Interface & Implementation**:
  - `lib/domain/repositories/phase_repository.dart`
  - `lib/data/repositories/phase_repository_impl.dart`
  - Wraps the API call, mapping successful results to the domain `Phase` entity and handling `DioException` errors into `ServerFailure`.
- **Use Case (`lib/domain/usecases/phase/get_phases_usecase.dart`)**: Created `GetPhasesUseCase` to conform to Clean Architecture principles.

### 2. State Management (Riverpod)
- **Phase Provider (`lib/presentation/providers/phase_provider.dart`)**: Created `phaseListProvider` as a `StateNotifierProvider` returning `AsyncValue<List<Phase>>`. It fetches the phases and ensures they are sorted by `orderIndex`.
- **Core Providers (`lib/presentation/providers/core_providers.dart`)**: Registered the new dependencies:
  - `phaseRepositoryProvider`
  - `getPhasesUseCaseProvider`

### 3. UI Integration
- **Your Program Screen (`lib/presentation/screens/home/your_program_screen.dart`)**:
  - Added synchronous dispatch of `ref.read(phaseListProvider.notifier).fetchPhases()` in `initState`.
  - Wrapped the phases section in `phaseState.when()`, rendering dummy locked/loading state while fetching, and real data once loaded.
  - Used `orderIndex` logic to determine active vs locked representations without blocking the entire screen render.
- **My Plan Screen (`lib/presentation/screens/my_plan/my_plan_screen.dart`)**:
  - Dispatched `fetchPhases()` in `initState`.
  - Wrapped the `_buildPhaseTimeline()` method in an `AsyncValue` listener.
  - Iterated through the fetched phases, rendering the exact UI sequence (Assess, Reset, Elevate, Sustain) securely with dynamic start and end connecting dots.

## Outcome
The application successfully retrieves Phase data dynamically. The UI remains fully non-blocking, rendering the rest of the application gracefully while the networking layer executes the phase request. Compilation warnings were reviewed and are not breaking the Phase feature logic.
