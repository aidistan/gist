// 快捷键加持 for 中国船舶党校 (https://www.csscdx.com/)
document.addEventListener("keydown", (event) => {
  if (event.key == "1") {
    $("[value=0]")[0].click()
  } else if (event.key == "2") {
    $("[value=1]")[0].click()
  } else if (event.key == "3") {
    $("[value=2]")[0].click()
  } else if (event.key == "4") {
    $("[value=3]")[0].click()
  } else if (event.key == "n") {
    $(".btn:contains('下一题')")[0].click()
  }
})
