import React from 'react'
import { useState } from 'react'
import mediaUpload from '../utils/mediaUpload.jsx'
const Testing = () => {

  const [count, setCount] = React.useState(0)

  const [file, setFile] = useState(null)


function uploadFile(){
  console.log(file);
  mediaUpload(file).then((url)=>{
    console.log(url);
  }).catch((error)=>{console.log(error)})
  
}


  return (
    <div className='w-full h-screen flex flex-col justify-center items-center'>

<input type="file" multiple  onChange={(e)=>{console.log(e.target.files);
setFile(e.target.files[0]) 
}}/>

<button className='my-5 w-[200px] h-[50px] bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600 transition-all duration-300' onClick={uploadFile}>Upload</button>
    









        
    </div>
  )
}

export default Testing