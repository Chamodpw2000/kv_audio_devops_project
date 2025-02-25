// import React, { useState } from 'react'
// import './additem.css'
// import axios from 'axios'

// const AddItem = () => {

//   const [item, setItem] = useState({
//     name: "",
//     key: "",
//     price: "",

//     category: "",
//     dimentions: "",
//     description: "",
//     image: "",
//     availability: ""
//   })


//   const handleClick = async () => {
//     const formData = new FormData();

//     // Append all fields
//     formData.append('name', item.name);
//     formData.append('key', item.key);
//     formData.append('price', item.price);
//     formData.append('category', item.category);
//     formData.append('dimentions', item.dimentions);
//     formData.append('description', item.description);
//     formData.append('availability', item.availability);

//     // If you have actual file uploads
//     // formData.append('image', selectedFile);

//     // If you want to keep using static URLs
//     formData.append('image', JSON.stringify(["https://picsum.photos/200/300", "https://picsum.photos/200/300"]));

//     console.log("Form Data:", formData);


//     try {
//       const res = await axios.post(
//         "http://localhost:3000/api/products/addProduct",
//         formData,
//         {
//           headers: {
//             "Authorization": "Bearer " + localStorage.getItem("token"),
//             "Content-Type": "application/json",
//           }
//         }
//       );
//       console.log(res);
//       setItem({
//         name: "",
//         key: "",
//         price: "",
//         category: "",
//         dimentions: "",
//         description: "",
//         image: "",
//         availability: ""
//       })
//     } catch (e) {
//       console.error(e);
//     }
//   };


//   return (

//     <div className='min-h-screen w-full flex items-center justify-center bg-picture    '>
//       <div className=' flex flex-col items-evenly justify-center w-[850px] h-[600px]  rounded-2xl backdrop-blur-xl  '>

//         <p className='text-3xl font-bold text-center text-white '> Add a New Item</p>



//         <div className='flex items-center justify-evenly p-5 '>


//           <div className="flex flex-col">

//             <div className='flex flex-col'>
//               <p className='p-2 text-white font-bold'> Item Name</p>




//               <input type="text" className='h-[50px] w-[350px]  rounded-2xl p-2 border-2 border-solid border-gray-950 ' placeholder='Item Name' value={item.name} onChange={
//                 (e) => setItem({ ...item, name: e.target.value })
//               } />
//             </div>
//             <div className='flex flex-col'>
//               <p className='p-2  text-white font-bold'> Item Price</p>




//               <input type="number" className='h-[50px] w-[350px]  rounded-2xl p-2 border-2 border-solid border-gray-950 ' placeholder='Item Price' value={item.price} onChange={
//                 (e) => setItem({ ...item, price: parseFloat(e.target.value) })
//               } />
//             </div>

//             <div className='flex flex-col'>
//               <p className='p-2  text-white font-bold'> Item Key</p>




//               <input type="text" className='h-[50px] w-[350px]  rounded-2xl p-2 border-2 border-solid border-gray-950 ' placeholder='Item Key' value={item.key} onChange={
//                 (e) => setItem({ ...item, key: e.target.value })
//               } />
//             </div>


//           </div>

//           <div>

//             <div className='flex flex-col'>
//               <p className='p-2 text-white font-bold'>Item Category</p>
//               <select
//                 className='h-[50px] w-[350px] rounded-2xl p-2 border-2 border-solid border-gray-950'
//                 value={item.category}
//                 onChange={(e) => setItem({ ...item, category: e.target.value })}


//               >
//                 <option></option>

//                 <option value="Audio">Audio</option>
//                 <option value="Video">Video</option>
//                 <option value="sounds">Sounds</option>

//               </select>
//             </div>

//             <div className='flex flex-col'>
//               <p className='p-2  text-white font-bold'> Item Dimentions</p>




//               <input type="text" className='h-[50px] w-[350px]  rounded-2xl p-2 border-2 border-solid border-gray-950 ' placeholder='Dimensions' value={item.dimentions} onChange={
//                 (e) => setItem({ ...item, dimentions: e.target.value })
//               } />
//             </div>
//             <div className='flex flex-col'>
//               <p className='p-2  text-white font-bold'> Item Availability</p>




//               <select
//   className='h-[50px] w-[350px] rounded-2xl p-2 border-2 border-solid border-gray-950'
//   value={item.availability.toString()}
//   onChange={(e) => setItem({ ...item, availability: e.target.value === 'true' })}
// >
// <option></option>

//   <option value="true">Available</option>
//   <option value="false">Not Available</option>
// </select>

//             </div>
//           </div>



//         </div>


//         <div className='flex items-center justify-center  '>

//           <div className='flex flex-col w-full px-14'>
//             <p className='p-2  text-white font-bold'>Description</p>
//             <textarea
//               className='h-[100px] w-full rounded-2xl p-2 border-2 border-solid border-gray-950 resize-none'
//               placeholder='Enter item description'
//               value={item.description}
//               onChange={(e) => setItem({ ...item, description: e.target.value })}
//             />
//           </div>



//         </div>


//         <div className='flex items-center justify-center '>
//           <button className='w-[200px] h-[50px] bg-[#f0ad38] text-white text-xl my-5 rounded-lg hover:bg-[#ffb12bee]' onClick={handleClick}>Add Item</button>
//         </div>









//       </div>

//     </div>
//   )
// }

// export default AddItem




import axios from 'axios';
import React, { useState } from 'react';
import toast from 'react-hot-toast';
import { useLocation, useNavigate } from 'react-router-dom';

const UpdateItem = () => {
  const navigate = useNavigate();
  const location = useLocation();

  console.log(location);
  






  const [productKey, setProductKey] = useState(location.state.key);
  const [productName, setProductName] = useState(location.state.name);
  const [productPrice, setProductPrice] = useState(location.state.price);
  const [productCategory, setProductCategory] = useState(location.state.category);
  const [productDimensions, setProductDimensions] = useState(location.state.
    dimentions);
  const [productDescription, setProductDescription] = useState(location.state.description);
  const [loading, setLoading] = useState(false); // Track API call state

  const handleUpdateItem = async () => {
    // Basic validation
    if (!productKey || !productName || !productPrice || !productCategory || !productDescription) {
      toast.error('Please fill in all required fields.');
      return;
    }

    const token = localStorage.getItem('token');
    if (!token) {
      toast.error('Please login to add items.');
      return;
    }

    try {
      setLoading(true); // Disable button during API call

      const result = await axios.put(
        'http://localhost:3000/api/products/' + productKey,
        {
          name: productName,
          price: productPrice,
          category: productCategory,
          dimensions: productDimensions,
          description: productDescription,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      toast.success(result.data.message);
      // Reset form fields
      setProductKey('');
      setProductName('');
      setProductPrice('');
      setProductCategory('audio'); // Reset to default
      setProductDimensions('');
      setProductDescription('');

      navigate('/admin/items');
    } catch (error) {
      console.error(error);
      toast.error('Error adding product. Please try again.');
    } finally {
      setLoading(false); // Re-enable button
    }
  };

  return (
    <div className='w-full h-full flex flex-col items-center justify-center'>
      <h1 className="text-2xl font-semibold mb-4"> Item</h1>

      <div className='w-[400px] border p-4 flex flex-col items-center rounded-lg shadow-md'>
        {/* Product Key */}
        <label className="w-full">Product Key</label>
        <input
        disabled
          className="w-full p-2 border rounded-md mb-2"
          onChange={(e) => setProductKey(e.target.value)}
          value={productKey}
          type="text"
          placeholder='Enter Product Key'
        />

        {/* Product Name */}
        <label className="w-full">Product Name</label>
        <input
          className="w-full p-2 border rounded-md mb-2"
          onChange={(e) => setProductName(e.target.value)}
          value={productName}
          type="text"
          placeholder='Enter Product Name'
        />

        {/* Product Price */}
        <label className="w-full">Product Price</label>
        <input
          className="w-full p-2 border rounded-md mb-2"
          type="number"
          placeholder='Enter Product Price'
          onChange={(e) => setProductPrice(e.target.value)}
          value={productPrice}
        />

        {/* Product Category */}
        <label className="w-full">Product Category</label>
        <select
          className="w-full p-2 border rounded-md mb-2"
          onChange={(e) => setProductCategory(e.target.value)}
          value={productCategory}
        >
          <option value="audio">Audio</option>
          <option value="lights">Lights</option>
        </select>

        {/* Product Dimensions */}
        <label className="w-full">Product Dimensions (optional)</label>
        <input
          className="w-full p-2 border rounded-md mb-2"
          type="text"
          placeholder='Enter Product Dimensions'
          onChange={(e) => setProductDimensions(e.target.value)}
          value={productDimensions}
        />

        {/* Product Description */}
        <label className="w-full">Product Description</label>
        <textarea
          className="w-full p-2 border rounded-md mb-4"
          type="text"
          placeholder='Enter Product Description'
          onChange={(e) => setProductDescription(e.target.value)}
          value={productDescription}
        />

        {/* Buttons */}
        <div className="flex w-full justify-between">
          <button
            onClick={handleUpdateItem}
            className={`px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition ${
              loading ? 'opacity-50 cursor-not-allowed' : ''
            }`}
            disabled={loading}
          >
            {loading ? 'Adding...' : 'Add'}
          </button>
          <button
            onClick={() => navigate('/admin/items')}
            className="px-4 py-2 bg-gray-500 text-white rounded-md hover:bg-gray-600 transition"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default UpdateItem;
