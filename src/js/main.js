const list_origin = document.querySelector("#list_numbers");
const list1 = document.querySelector("#list_numbers_1");
const list2 = document.querySelector("#list_numbers_2");
const list3 = document.querySelector("#list_numbers_3");
const list4 = document.querySelector("#list_numbers_4");

const allNumbers =
  "https://db.ygoprodeck.com/api/v7/cardinfo.php?archetype=Number&type=XYZ%20Monster";
const xyzNumbers =
  "https://db.ygoprodeck.com/api/v7/cardinfo.php?type=XYZ%20Monster&fname=Number";

let data = "";

let table, table1, table2, table3, table4;

async function init() {
  data = await fetch(allNumbers)
    .then((res) => res.json())
    .catch((error) => console.log(error));
  data = data.data;
  let data_xyz = await fetch(xyzNumbers).then((users) => users.json());
  data = data.concat(data_xyz.data);
  //   console.log(data);
  let ids = [];
  data = data
    .filter((element) => {
      if (ids.includes(element.id)) {
        return false;
      } else {
        ids.push(element.id);
        return true;
      }
    })
    .filter((element) => getNumber(element.name));
  //   console.log(data);

  table = makeList();
  createOptions(table, list_origin);
  list_origin.dispatchEvent(new Event("change"));
}

init();

list_origin.addEventListener("change", () => {
  var index = data.findIndex((element) => element.name === list_origin.value);

  document.querySelector("#card-origin").innerHTML = `<img
  class="fit-picture"
  src="${data[index].card_images[0].image_url_small}" />`;

  table1 = getTruncatedList(makeList(), getNumber(data[index].name));

  createOptions(table1, list1);

  list1.dispatchEvent(new Event("change"));
});

list1.addEventListener("change", () => {
  var index = data.findIndex((element) => element.name === list_origin.value);
  var index1 = data.findIndex((element) => element.name === list1.value);
  var index2 = data.findIndex((element) => element.name === list2.value);
  var index3 = data.findIndex((element) => element.name === list3.value);
  var index4 = data.findIndex((element) => element.name === list4.value);

  var rank = getRank(list1.value);

  //   removeRank(table1, rank);

  var maxNumber =
    parseInt(getNumber(data[index].name)) -
    parseInt(getNumber(data[index1].name));

  table2 = getTruncatedList(removeRank(table1, rank), maxNumber);

  createOptions(table2, list2);

  list2.dispatchEvent(new Event("change"));

  document.querySelector("#img_number1").innerHTML = `<img
  class="fit-picture"
  src="${data[index1].card_images[0].image_url_small}" />`;
});
list2.addEventListener("change", () => {
  var index = data.findIndex((element) => element.name === list_origin.value);
  var index1 = data.findIndex((element) => element.name === list1.value);
  var index2 = data.findIndex((element) => element.name === list2.value);
  var index3 = data.findIndex((element) => element.name === list3.value);
  var index4 = data.findIndex((element) => element.name === list4.value);

  var rank = getRank(list2.value);

  var maxNumber =
    parseInt(getNumber(data[index].name)) -
    parseInt(getNumber(data[index1].name)) -
    parseInt(getNumber(data[index2].name));

  table3 = getTruncatedList(removeRank(table2, rank), maxNumber);

  createOptions(table3, list3);

  list3.dispatchEvent(new Event("change"));

  document.querySelector("#img_number2").innerHTML = `<img
  class="fit-picture"
  src="${data[index2].card_images[0].image_url_small}" />`;
});
list3.addEventListener("change", () => {
  var index = data.findIndex((element) => element.name === list_origin.value);
  var index1 = data.findIndex((element) => element.name === list1.value);
  var index2 = data.findIndex((element) => element.name === list2.value);
  var index3 = data.findIndex((element) => element.name === list3.value);
  var index4 = data.findIndex((element) => element.name === list4.value);

  var rank = getRank(list3.value);

  var maxNumber =
    parseInt(getNumber(data[index].name)) -
    parseInt(getNumber(data[index1].name)) -
    parseInt(getNumber(data[index2].name)) -
    parseInt(getNumber(data[index3].name));

  table4 = getTruncatedList(removeRank(table3, rank), maxNumber);

  table4 = table4.filter((element) => {
    // console.log(
    //   `Number element: ${getNumber(element)}/ maxNumber: ${maxNumber}`
    // );
    return parseInt(getNumber(element)) === parseInt(maxNumber);
  });

  // console.log(`maxNumber: ${maxNumber}`);

  createOptions(table4, list4);

  list4.dispatchEvent(new Event("change"));

  document.querySelector("#img_number3").innerHTML = `<img
  class="fit-picture"
  src="${data[index3].card_images[0].image_url_small}" />`;
});

list4.addEventListener("change", () => {
  var index4 = data.findIndex((element) => element.name === list4.value);
  document.querySelector("#img_number4").innerHTML = `<img
  class="fit-picture"
  src="${data[index4].card_images[0].image_url_small}" />`;
});

function makeList() {
  return data.map((element) => element.name).sort(sortNumbers);
}

function createOptions(liste, selectId) {
  // console.log(liste);
  selectId.innerHTML = "";
  liste.forEach((element) => {
    selectId.innerHTML +=
      '<option value="' + element + '">' + element + "</option>";
  });
}

function sortNumbers(a, b) {
  numberA = a.replace(/(Number )([^:]+)/, "$2").replace(/([^0-9]+)/, "");
  numberB = b.replace(/(Number )([^:]+)/, "$2").replace(/([^0-9]+)/, "");
  if (parseInt(numberA) < parseInt(numberB) || numberB == "") {
    return -1;
  }
  if (parseInt(numberA) > parseInt(numberB) || numberA == "") {
    return 1;
  }
  return 0;
}

function getNumber(name) {
  // /([0-9]+)/
  var jsonObj = data.find((element) => element.name === name);
  if (jsonObj.name.match(/([0-9]+)/)) {
    return jsonObj.name.match(/([0-9]+)/)[0];
  } else if (jsonObj.desc.includes("This card is always treated as")) {
    return jsonObj.desc.match(/(Number )([^0-9]+|)([0-9]+)/)[3];
  } //This card is always treated as
  else {
    return false;
  }
}

function getTruncatedList(list, number) {
  return list.filter((element) => {
    var elemNumber = getNumber(element);
    if (parseInt(elemNumber) <= number) {
      return true;
    } else return false;
  });
}

function getRank(name) {
  // /([0-9]+)/
  var jsonObj = data.find((element) => element.name === name);
  return jsonObj.level == 0 ? 1 : jsonObj.level;
}

function removeRank(list, number) {
  return list.filter((element) => {
    var jsonObj = data.find((obj) => obj.name === element);
    // console.log(`Level: ${jsonObj.level} and Number: ${number}`);
    return parseInt(jsonObj.level == 0 ? 1 : jsonObj.level) != parseInt(number);
  });
}

// data.map((element) => element.level);
