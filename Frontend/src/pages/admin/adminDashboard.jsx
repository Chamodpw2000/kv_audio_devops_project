import React from 'react'
import { MdOutlineDashboard } from 'react-icons/md'
import { TbBrandBooking } from 'react-icons/tb'
import { CgMusicSpeaker } from 'react-icons/cg'
import { FaBackward, FaRegUser } from 'react-icons/fa'
import { Route, Routes ,Link } from 'react-router-dom'
import Itemsadmin from './itemsAdmin'
import AddItem from '../../components/addItem'
import ItemsPageAdmin from './itemsPage'
import UpdateItem from '../home/updateItemPage'
const AdminDashboard = () => {
    return (
        <div>


            <div className='w-full min-h-screen  flex'>

                <div className='w-[200px] min-h-full bg-green-200'>

                    <Link to="/admin" className="w-full h-[40px] text-[25px] font-bold flex items-center justify-center">
                        <MdOutlineDashboard className="w-[25px] h-[25px]" />
                        Dashboard</Link>

                    <Link to="/admin/bookings" className="w-full h-[40px] text-[25px] font-bold flex items-center justify-center">
                        <TbBrandBooking className="w-[25px] h-[25px]" />
                        Bookings</Link>


                    <Link to="/admin/items" className="w-full h-[40px] text-[25px] font-bold flex items-center justify-center">
                        <CgMusicSpeaker className="w-[25px] h-[25px]" /> Items
                    </Link>

                    <Link to="/admin/users" className="w-full h-[40px] text-[25px] font-bold flex items-center justify-center">
                        <FaRegUser className="w-[25px] h-[25px]" /> Users
                    </Link>

                    <Link to="/" className="w-full h-[40px] text-[25px] font-bold flex items-center justify-center">
                        <FaBackward className="w-[25px] h-[25px]" />Back
                    </Link>






                </div >

                <div className="w-full bg-slate-300">





                    <Routes path="/*" >
                        <Route path="/" element={<h1> Dashboard </h1>} />

                        <Route path="/bookings" element={<h1> Bookings </h1>} />
                        <Route path="/items" element={<ItemsPageAdmin />} />    
                        <Route path="/users" element={<h1> Users </h1>} />
                        <Route path="/additem" element={<AddItem/>} />
                        <Route path="/items/edit" element={<UpdateItem/>} />





                    </Routes>
                </div>









            </div>




        </div>
    )
}

export default AdminDashboard