//

const NumbersEveil =
  "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Numbers%20Eveil";

let data = "";

let table, table1, table2, table3, table4;

async function init() {
  data = await fetch(NumbersEveil)
    .then((res) => res.json())
    .catch((error) => console.log(error));
  data = data.data[0];

  document.querySelector("#img_numbersEveil").src =
    data.card_images[0].image_url;

  document.querySelector("#effect").innerHTML = data.desc;
}

init();
