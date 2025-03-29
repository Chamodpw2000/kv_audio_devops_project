import React, { useEffect, useState } from 'react'
import axios from 'axios'
import productCard from '../../components/productCard'
import ProductCard from '../../components/productCard'

const Items = () => {

const [state, setState] = useState("loading") // loading, success, error
  const [products,setProducts] = useState([])

  useEffect(()=>{
    if(state==="loading"){axios.get("http://localhost:3000/api/products/getProducts").then((res)=>{
      console.log(res.data)
      setProducts(res.data)
      setState("success")

    }).catch((err)=>{
      console.log(err)
      toString.error(err?.response?.data?.error||"An error occured")
      setState("error")
    })}
    },[])
  return (
    <div className='w-full h-full flex flex-wrap justify-center bg-red-100 p-5 '>






{
  state==="loading" && <div className='w-full h-full flex justify-center items-center'>


    <div className='w-[50px] h-[50px] border-4 border-t-4 border-t-green-500 rounded-full animate-spin'></div>

    



  </div>
}


{

state==="success" && products.map((item)=>{


  return(
   <ProductCard item={item} key={item._id} />
  )

})

}

      






    </div>
  )
}

export default Items