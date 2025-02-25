import React, { useState } from 'react'
import './login.css'
import axios from 'axios'
import toast from 'react-hot-toast'
import { useNavigate } from 'react-router-dom'

const LoginPage = () => {
    const [email, setEmail] = useState('')
    const [password, setPassword] = useState('')
    const navigate = useNavigate();

    function login() {


        console.log(
            email,
            password
        );

        axios.post("http://localhost:3000/api/users/login", {
            email: email,
            password: password

        }
        ).then((res) =>{ console.log(res),
            toast.success("Login Success")
            const user = res.data.user
            localStorage.setItem("token", res.data.token)
            localStorage.setItem("user", JSON.stringify(user))
            if(user?.role === "admin"){
               navigate('/admin')
            }
            if(user?.role === "customer"){
                navigate('/home')
            }

        }
        ).catch((e) => {
            console.log(e),
            toast.error(e.response.data.message || e.response.data.error )
          
        })



    }


    return (
        <div className='w-full h-screen flex justify-center items-center bg-picture '>

            <div className='w-[400px] h-[400px] backdrop-blur-xl rounded-2xl flex justify-center items-center flex-col relative'>


                <img src="/logo.png" className='w-[100px] h-[100px]  top-1 object-cover' />

                <input placeholder='Email' className='w-[300px] h-[50px] bg-transparent border-b-2 border-white text-white text-2xl outline-none' value={email} onChange={(e) => setEmail(e.target.value)} />
                <input type="password" placeholder='Password' className='w-[300px] h-[50px] bg-transparent border-b-2 border-white text-white text-2xl outline-none' value={password} onChange={(e) => setPassword(e.target.value)} />
                <button className='w-[300px] h-[50px] bg-[#f0ad38] text-white text-xl my-5 rounded-lg hover:bg-[#ffb12bee]' onClick={login} >Login</button>




            </div>


        </div>
    )
}

export default LoginPage