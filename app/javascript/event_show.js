console.log("Hello, World!")

function userSearch() {
  let input = document.getElementById('user_invitation_search_bar');
  let filter = input.value.toUpperCase();
  let list = document.getElementById('user_invitation_search_list');

  for (var i = 0; i < list.children.length; ++i) {
    let li = list.children[i]
    let name = li.textContent || a.innerText
    if (name.toUpperCase().includes(filter)) {
      li.style.display = "";
    }else{
      li.style.display = "none";
    }
  }
}

let input = document.getElementById('user_invitation_search_bar');
input.addEventListener("keyup", userSearch)
