import React from 'react'

const ItemsCard = ({item}) => {
console.log("===============inside item Card==========================");

  console.log('Item:', item) // Debug log;
  
  return (
    <div className="max-w-sm mx-auto transform transition duration-300 hover:scale-105 hover:shadow-xl">
      <div className='h-full w-full bg-white flex flex-col items-center p-6 rounded-xl shadow-lg border border-gray-100'>
        
        {/* Image Container */}
        <div className='relative w-full aspect-square overflow-hidden rounded-xl mb-4'>
          <img 
            src='https://cdn.dotpe.in/longtail/store-items/6983279/HawDsdnx.webp' 
            className='h-full w-full object-cover hover:scale-110 transition-transform duration-300'
            alt='Bluetooth Speaker'
          />
        </div>

        {/* Product Info */}
        <div className="w-full space-y-4">
          <h3 className='text-2xl font-bold text-gray-800 text-center'>
            {item.name}
          </h3>
          
          <p className='text-2xl font-bold text-gray-800 text-center'>
            {item.key}
          </p>

          
          <div className='flex justify-between items-center bg-gray-50 px-4 py-2 rounded-lg'>
            <span className='text-sm font-semibold text-gray-600'>Category:</span>
            <span className='text-sm font-medium text-indigo-600'>{item.category}</span>
          </div>

          <div className='flex justify-between items-center bg-gray-50 px-4 py-2 rounded-lg'>
            <span className='text-sm font-semibold text-gray-600'>Dimensions:</span>
            <span className='text-sm font-medium text-gray-700'>{item.dimentions}</span>
          </div>

          <p className='text-gray-600 text-center leading-relaxed'>
           {item.description}
          </p>

          <div className='flex justify-between items-center pt-4'>
            <span className='text-3xl font-bold text-indigo-600'>LKR {item.price}</span>
            <button className='bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-3 rounded-lg font-medium transition-colors duration-200'>
              Order
            </button>
          </div>
        </div>

      </div>
    </div>
  )
}

export default ItemsCard