
export type HasAnyCallback<T> = (it: T) => boolean;

export default class List<T> {
  _items : Array<T>;

  private _length = 0;
  public get length(): Number { return this._length }

  constructor(n? : number, defaultValue? : T) {
    if ( n === undefined) {
      this._items = [];
    } else {
      if ( n && defaultValue){
        this._items = Array(n).fill(defaultValue);
      } else {
        this._items = Array(n);
      }
    }
  }

  push(item : T) {
    this._length += 1
    this._items.push(item);
  }

  pop(item : T) {
    this._length -= 1
    return this._items.pop();
  }

  get(index : number) : T | undefined {
    return this._items[index];
  }

  set(index : number, item : T){
    this._items[index] = item;
  }

  getItems() : Array<T> {
    return this._items;
  }

  hasAny(cb: HasAnyCallback<T>): boolean {
    for (let it of this.getItems()) { if (cb(it)) return true }
    return false
  }

  getFirst(cb: HasAnyCallback<T>): T | null {
    for (let it of this.getItems()) { if (cb(it)) return it }
    return null
  }

  static fix_<T>(data: List<T>, dataType: any): List<T> {
    let res = new List<T>()
    for (let it of data._items) {
      res.push(dataType.fix_(it));
    }
    return res
  }

}
