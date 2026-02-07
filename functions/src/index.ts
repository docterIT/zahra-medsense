import * as functions from "firebase-functions";
import { analyzeParkinson } from "./gemini";

export const onVideoUploaded = functions.storage.object().onFinalize(async (object) => {
    const filePath = object.name;
    if (!filePath?.startsWith("screenings/") || !filePath.endsWith(".mp4")) return;
    
    console.log(`Processing new screening video: ${filePath}`);
    try {
        await analyzeParkinson(filePath);
    } catch (error) {
        console.error("Analysis failed:", error);
    }
});
