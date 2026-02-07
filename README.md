# Zahra MedSense (Z.A.H.R.A)
### Zenith AI for Health & Recovery Analysis

Zahra MedSense is an innovative neurological screening tool designed for the Gemini 3 Hackathon 2026. It utilizes Gemini 1.5 Pro's multimodal capabilities to detect early signs of Parkinson's and Stroke.

## Technical Architecture
- **Frontend**: Flutter (Android, iOS, Web)
- **AI Engine**: Gemini 3 (1.5 Pro) via Vertex AI API
- **Backend**: Firebase Cloud Functions & Storage
- **Medical Standards**: MDS-UPDRS (Parkinson's) & CPSS (Stroke)

## Development Setup

### 1. Flutter App
To run the Flutter app:
```bash
flutter pub get
flutter run
```

### 2. Backend Functions
To deploy the AI engine:
```bash
cd functions
npm install
npm run deploy
```

## Features
- **Vision**: Micro-tremor tracking (4-6 Hz) and facial symmetry analysis.
- **Acoustic**: DDK ("pa-ta-ka") repetition and Dysarthria detection.
- **Reasoning**: Comparing current assessments with historical medical data.

---
*Created for Gemini 3 Hackathon 2026*
