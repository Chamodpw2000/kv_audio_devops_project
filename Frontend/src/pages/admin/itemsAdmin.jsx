import React, { useEffect, useState } from 'react'
import ItemsCard from '../../components/itemsCard'
import axios from 'axios'
import { useNavigate } from 'react-router-dom'

const Itemsadmin = () => {
    const [items, setItems] = useState([])
    const [loading, setLoading] = useState(true)
    const navigate = useNavigate();
    useEffect(() => {
        const fetchItems = async () => {
            try {
                const response = await axios.get('http://localhost:3000/api/products/getProducts')
                console.log('Full API Response:', response.data) // Debug log
                setItems(response.data)
            } catch (error) {
                console.log('Error fetching items:', error)
            } finally {
                setLoading(false)
            }
        }

        fetchItems()
    }, [])

    // Debug log to check items state
    useEffect(() => {
        console.log('Current items state:', items)
    }, [items])

    if (loading) {
        return (
            <div className="flex items-center justify-center min-h-screen">
                <div className="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
            </div>
        )
    }
    // const navigate = useNavigate();
    return (
        <div className="container mx-auto px-4 py-8">



<button className='w-[300px] h-[50px] bg-[#f0ad38] text-white text-xl my-5 rounded-lg hover:bg-[#ffb12bee]' onClick={()=>{navigate("/admin/additem")}} >Add Item</button>

            <h1 className="text-3xl font-bold mb-8 text-gray-800">
                Items Management ({items.length} items)
            </h1>
            
            {items.length === 0 ? (
                <div className="text-center text-gray-600">
                    No items found
                </div>
            ) : (
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    {items.map((item) => (
                        console.log('Item:', item), // Debug log;
                        
                        <ItemsCard key={item._id} item={item} />
                    ))}
                </div>
            )}
        </div>
    )
}

export default Itemsadmin
