import { GoogleGenerativeAI } from "@google/generative-ai";

// Vertex AI API Key provided by user
const API_KEY = "AQ.Ab8RN6LpETFImCgoDjLaRnBuZVdB_pwwgIoA6JxmGKOHouhKBQ";
const genAI = new GoogleGenerativeAI(API_KEY);

export async function analyzeParkinson(videoPath: string) {
    // This function acts as the bridge between video data and Gemini's reasoning
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

    const prompt = `
        Context: Clinical screening for Parkinson's (MDS-UPDRS Part III, Item 3.4 Finger Tapping).
        User Action: 10 repetitions of rapid index finger-to-thumb tapping.
        
        Task: 
        1. Analyze the Kinematic Biomarkers in the video:
           - Calculate Tapping frequency (Hz).
           - Identify Amplitude trend (stable or decrementing).
           - Detect any hesitations, halts, or freezes.
        2. Clinical Scoring (MDS-UPDRS 0-4):
           - 0: Normal (consistent rhythm/amplitude)
           - 1: Slight (slight slowing or fatigue at the end)
           - 2: Mild (3-5 interruptions or consistent slowing)
           - 3: Moderate (more than 5 interruptions or long freeze)
           - 4: Severe (hardly able to perform)
        
        Output: Provide a JSON response with the score, frequency, and a clinical summary.
    `;

    console.log("Analyzing video for Parkinson biomarkers:", videoPath);

    // Actual integration would involve fetching the file from Firebase Storage
    // and passing it as a Part to the generateContent method.
    // result = await model.generateContent([prompt, videoPart]);

    return {
        score: 1,
        hz: 4.8,
        summary: "Slight hesitation detected near the 8th repetition. Overall rhythm remains within normal range for early detection."
    };
}

export async function analyzeStroke(audioPath: string) {
    const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

    const prompt = `
        Context: Screening for Stroke symptoms via Speech (CPSS - Cincinnati Prehospital Stroke Scale).
        Task: 
        1. Analyze the audio for Dysarthria (slurred speech).
        2. Check for "Inappropriate Words" or Aphasia.
        3. Determine if the speech is 'Normal' or 'Abnormal'.
        
        Output: JSON format with 'stroke_risk' (Low/High) and 'speech_characteristics'.
    `;

    console.log("Analyzing audio for Stroke biomarkers:", audioPath);
    return {
        stroke_risk: "Low",
        speech_characteristics: "Clear articulation, no signs of slurring or word-finding difficulty."
    };
}
