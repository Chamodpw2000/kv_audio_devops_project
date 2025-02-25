import React from 'react'
import { Link } from 'react-router-dom'

const NotFound = () => {
  return (
  
  
  
<div className='flex flex-col items-center justify-center  h-[calc(100vh-100px)] w-full bg-blue-100'>
  
      <div>Page Not Found</div>

      <Link className="bg-[#f0ad38] p-3 rounded-xl" to="/" >Back to Home Page </Link>
  
  
  
  </div>

  )
}

export default NotFound