import React from "react";

const Main = () => {
  return (
    <div className="flex bg-gray-700 justify-center">
      <div class="w-full max-w-xs py-4 mt-2">
        <form class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
          <div className="flex "id="one">
            <div class="flex  w-3/4">
              <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="username" type="text" placeholder="0"/>
            </div>
            <div className="border rounded w-1/4">
                Ether
            </div>
          </div>
          <div className="flex "id="one">
            <div class="flex  w-3/4">
              <input class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id="username" type="text" placeholder="0"/>
            </div>
            <div className="border rounded w-1/4">
                Token
            </div>
          </div>
          <div class="flex items-center justify-center">
            <button
              class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded w-full"
              type="button"
            >
              Swap
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Main;
