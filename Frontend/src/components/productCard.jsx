import React from "react";

const ProductCard = ({ item }) => {
    return (
        <div className="max-w-sm shadow-lg rounded-lg overflow-hidden border bg-white border-gray-200 m-5">
            {/* Product Image */}
            <img className="w-full h-56 object-cover" src={item.image[0]} alt={item.name} />

            {/* Product Details */}
            <div className="px-4 pt-4 bg-white">
                <h2 className="text-xl font-semibold text-gray-800">{item.name}</h2>
                <p className="text-gray-600 text-sm mt-1">{item.description}</p>

                {/* Price & Availability */}
                <div className="flex justify-between items-center mt-4">
                    <span className="text-lg font-bold text-blue-600">{item.price.toFixed(2)} LKR</span>
                    <span
                        className={`px-2 py-1 text-xs font-semibold rounded ${item.availability ? "bg-green-100 text-green-700" : "bg-red-100 text-red-700"
                            }`}
                    >
                        {item.availability ? "In Stock" : "Out of Stock"}
                    </span>
                </div>

                {/* Category & Dimensions */}
                <div className="mt-3 text-sm text-gray-500">
                    <p><strong>Category:</strong> {item.category}</p>
                    <p><strong>Dimensions:</strong> {item.dimentions}</p>
                </div>

                {/* Add to Cart Button */}
                <button
                    className="mt-4 w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700 transition"
                >
                    Add to Cart
                    
                </button>
            </div>
        </div>
    );
};

export default ProductCard;
