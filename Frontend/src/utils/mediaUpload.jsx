import { createClient } from "@supabase/supabase-js";

const anon_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlid25hYWpwZHRjcXptZ3Joc3lmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4OTk3NDQsImV4cCI6MjA1NTQ3NTc0NH0.FHxAeUa0ht4kIvaCJbTKU7NL7fVt8vLiv27eVoEnpcM";
const superbase_url = "https://ibwnaajpdtcqzmgrhsyf.supabase.co";

const superbase = createClient(superbase_url, anon_key);

export default function mediaUpload(file) {

    return new Promise((resolve, reject) => {

        if (file === null) {
            reject("No File Selected");
        }


        const timestamp = new Date().getTime();
        const fileName = timestamp + file.name;
        superbase.storage.from("images").upload(fileName, file, { cacheControl: '3600', upsert: false }).then(() => {

            const publicUrl = superbase.storage.from("images").getPublicUrl(fileName).data.publicUrl;
            resolve(publicUrl)
        }).catch(() => {
            reject("Upload Failed");
        })


    });



}

