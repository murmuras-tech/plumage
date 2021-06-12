const ariaButton = require("@react-aria/button")

exports.useButtonImpl = ariaButton.useButton

exports.toDashedProps = (psProps) => {
  const arias = psProps.hasOwnProperty("_aria")
    ? Object.fromEntries(
        Object.entries(psProps._aria).map(([key, value]) => [
          "aria-" + key,
          value,
        ])
      )
    : {}
  const datas = psProps.hasOwnProperty("_data")
    ? Object.fromEntries(
        Object.entries(psProps._data).map(([key, value]) => [
          "data-" + key,
          value,
        ])
      )
    : {}
  const reactProps = Object.assign({}, psProps, arias, datas)
  delete reactProps._aria
  delete reactProps._data
  return reactProps
}

exports.fromDashedProps = (reactProps) => {
  console.log("Hi, I'm from dashed props", reactProps)
  const psProps = {}
  _aria = {}
  _data = {}
  Object.entries(reactProps.buttonProps).forEach(([key, value]) => {
    if (key.startsWith("aria-")) {
      _aria[key.slice(5)] = value
    } else if (key.startsWith("data-")) {
      _data[key.slice(5)] = value
    } else {
      psProps[key] = value
    }
    console.log(psProps)
  })
  if (Object.keys(_aria).length !== 0) {
    psProps._aria = _aria
  }
  if (Object.keys(_data).length !== 0) {
    psProps._data = _data
  }
  reactProps.buttonProps = psProps
  return reactProps
}
