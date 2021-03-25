import axios from 'axios';
import { lineFoods } from '../urls/index'
import { lineFoodsReplace } from '../urls/index'

export const postLineFoods =(params) => {
  // 引数にリクエスト先のURL文字列、そして第二引数にパラメーターを渡します
  return axios.post(lineFoods,
    {
      food_id: params.foodId,
      count: params.count,
    }
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};

export const replaceLineFoods = (params) => {
  return axios.put(lineFoodsReplace,
    {
      food_id: params.foodId,
      count: params.count,
    }
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};

export const fetchLineFoods = () => {
  return axios.get(lineFoods)
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};