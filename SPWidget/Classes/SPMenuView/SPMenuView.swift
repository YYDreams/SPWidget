//
//  SPMenuView.swift
//  SPWidget
//
//  Created by flowerflower on 2021/12/4.
//

import Foundation


// MARK: ------------------------- Const/Enum/Struct

extension SPMenuView {
    
    /// 常量
    struct Const {
        static let arrowHeight:CGFloat = 10
        static let arrowWidth: CGFloat = 15
        static let CellIdentifier = "SPMenuViewCellID"
        static let animationTime  =  0.25
        static let defaultMargin:CGFloat  =  10
        static let kScreenWidth  = UIScreen.main.bounds.size.width
        static let kScreenHeight  = UIScreen.main.bounds.size.height
        static let kMainWindow  = UIApplication.shared.keyWindow
    }
    
    /// 内部属性
    struct Porpertys {
//        var refPoint: CGPoint?
//        var menuWidth: CGFloat? = 200
//        var arrowPosition: CGFloat? //三角底部的起始点x
//        var topMargin: CGFloat? //
//        var isReverse: Bool? //是否反向
//        var needReload: Bool = false //是否需要刷新
 
    }
    
    /// 外部参数
    struct Params {
         var superView: UIView?
         var  dataArr = [String]()
    }
    
}

public class SPMenuView: UIView {
    
    
    // MARK: ------------------------- Propertys
  public  var callBackBlock:((_ menu:SPMenuView, _ selectTitle : String?, _ selectIndex: Int)->Void)?

    /// 内部属性
    var propertys: Porpertys = Porpertys()
    /// 外部参数
    var params: Params = Params()
    
    //默认圆角   default = 5.0
    var cornerRaius: CGFloat = 5.0
    
    //设置分割线颜色 default = 灰色
    var separatorColor: UIColor = UIColor.lightGray
    
    //设置菜单颜色  default = 白色（也可以通过BackgroundColor设置）
    var menuColor: UIColor = UIColor.white

    //设置菜单单元格高度  default = 44
    var menuCellHeight:CGFloat = 44

    //最大显示数量  default = 5
    var maxDisplayCount:Int = 44
    
   //是否显示阴影 default = true(默认设置，也可以自己通过layer属性设置)
    var isShowShadow: Bool = true
    
    //选择菜单选项后消失 default = true
    var dismissOnselected: Bool = true
    
    //点击菜单外消失 default = true
    var dismissOnTouchOutside: Bool = true
    
    //设置字体大小 default = 15
    var textFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    //设置字体颜色 default = 黑色
    var textColor: UIColor = UIColor.black
    
    //设置偏移y距离 default = 0（与触摸点在Y轴上的偏移）
    var offsetY: CGFloat = 0
    
    //设置偏移x距离 default = 0（与触摸点在X轴上的偏移）
    var offsetX: CGFloat = 0
    
    
    var refPoint: CGPoint = CGPoint(x: 0,y: 0)
    var menuWidth: CGFloat = 100
    var arrowPosition: CGFloat = 0 //三角底部的起始点x
    var topMargin: CGFloat = 0 //
    var isReverse: Bool = false //是否反向
    var needReload: Bool = false //是否需要刷新
    
    
    var bgView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.alpha = 0.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    var refView: UIView?
    
    var contentView: UIView?
    
    var tableView: UITableView?
    
        
    // MARK: ------------------------- CycLife
    fileprivate convenience init(superView: UIView?, dataArr: [String]?,currentTitle: String? = nil) {
        self.init()
        self.params.superView = superView
        self.params.dataArr = dataArr ?? []
        
    }
  public   class func create(superView: UIView?, dataArr: [String]?,currentTitle: String? = nil) -> SPMenuView {
        let view = SPMenuView(superView: superView, dataArr: dataArr,currentTitle: currentTitle)
        view.setupView()
        view.setupData()
        return view
    }

  
    // MARK: ------------------------- Events
    func setupView(){
        setupArrow()
        
                
        self.contentView = {
            let view = UIView(frame: self.bounds)
            view.backgroundColor = menuColor
            view.layer.masksToBounds = true
            self.addSubview(view)
            return view
        }()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        self.bgView.addGestureRecognizer(tap)
        
        setupMaskLayer()
        self.tableView = {
            
            let tableView = UITableView(frame: CGRect(x: 0, y: topMargin, width: self.frame.width, height: self.frame.height - Const.arrowHeight), style: .plain)
            tableView.backgroundColor = UIColor.clear
            tableView.delegate = self
            tableView.dataSource = self
            tableView.bounces = self.params.dataArr.count > maxDisplayCount ? true : false;
            tableView.rowHeight = menuCellHeight;
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            self.contentView?.addSubview(tableView)
            tableView.register(SPMenuCell.self, forCellReuseIdentifier: Const.CellIdentifier)
            return tableView
        }()
    }
    func setupArrow(){
        
        if (self.params.superView != nil) {
            refPoint = self.getRefPoint()
        }
        var  originX: CGFloat
        var  originY: CGFloat
        var  width: CGFloat
        var  height: CGFloat
        
        width = menuWidth
        let maxHeight  = CGFloat(maxDisplayCount) * menuCellHeight + Const.arrowHeight
        let minHeight  = CGFloat(self.params.dataArr.count) * menuCellHeight + Const.arrowHeight
        
        height = self.params.dataArr.count > maxDisplayCount ? maxHeight :minHeight
        // 默认在中间
        
        arrowPosition = 0.5 * width - 0.5 * Const.arrowWidth
        
        // 设置出menu的x和y（默认情况）

        originX = refPoint.x  - arrowPosition - 0.5 * Const.arrowWidth

        originY = refPoint.y
        
        // 考虑向左右展示不全的情况，需要反向展示
        if (originX + width > UIScreen.main.bounds.width - 10) {
            originX = Const.kScreenWidth - Const.defaultMargin - width;
        }else if (originX < 10) {
            //向上的情况间距也至少是kDefaultMargin
            originX = Const.defaultMargin
        }
        
        //设置三角形的起始点
        
        if ((refPoint.x <= originX + width - cornerRaius) && (refPoint.x >= originX + cornerRaius)) {
            arrowPosition = refPoint.x - originX - 0.5 * Const.arrowWidth;
        }else if (refPoint.x < originX + cornerRaius) {
            arrowPosition = cornerRaius;
        }else {
            arrowPosition = width - cornerRaius - Const.arrowWidth;
        }
        
        //如果不是根据关联视图，得算一次是否反向
        if ((self.params.superView == nil)) {
            isReverse = (originY + height > Const.kScreenHeight - Const.defaultMargin) ? true : false;
        }
        
        var  anchorPoint:CGPoint
        if (isReverse) {
            originY = refPoint.y - height;
            anchorPoint = CGPoint(x: abs(arrowPosition) / width, y: 1);
            topMargin = 0;
        }else{
            anchorPoint = CGPoint(x: abs(arrowPosition) / width, y: 0);
            topMargin = Const.arrowHeight;
        }
        originY += originY >= refPoint.y ? offsetY : -offsetY;
        
        //保存原来的frame，防止设置锚点后偏移
        self.layer.anchorPoint = anchorPoint;
        self.frame = CGRect(x: originX, y: originY, width: width, height: height);
    }
    func getRefPoint() -> CGPoint{

        let  absoluteRect = self.params.superView!.convert(self.params.superView!.bounds, to: UIApplication.shared.keyWindow)
        
        var  refPoint:CGPoint;
        let maxHeight  = CGFloat(maxDisplayCount) * menuCellHeight + Const.arrowHeight
        let minHeight  = CGFloat(self.params.dataArr.count) * menuCellHeight + Const.arrowHeight
        let menuHeight = (self.params.dataArr.count > maxDisplayCount) ? maxHeight : minHeight
        
        if (absoluteRect.origin.y + absoluteRect.size.height +  menuHeight > UIScreen.main.bounds.height - 10) {
            refPoint = CGPoint(x: absoluteRect.origin.x + absoluteRect.size.width / 2, y: absoluteRect.origin.y)
            isReverse = true
        }else{
            refPoint = CGPoint(x: absoluteRect.origin.x + absoluteRect.size.width / 2, y: absoluteRect.origin.y + absoluteRect.size.height)
            isReverse = false
        }
        return refPoint;

    }
    func setupMaskLayer(){
        let layer = self.drawMaskLayer()
        self.contentView?.layer.mask = layer
        
        
        
    }
    func drawMaskLayer() -> CAShapeLayer{
        
        let maskLayer = CAShapeLayer()
        let bottomMargin  = !isReverse ? 0 : Const.arrowHeight
        
        // 定出四个转角点
        let topRightArcCenter = CGPoint(x: self.frame.width - cornerRaius, y: topMargin + cornerRaius)
        let topLeftArcCenter = CGPoint(x:cornerRaius, y:topMargin + cornerRaius);
        let bottomRightArcCenter = CGPoint(x:self.frame.width - cornerRaius, y:self.frame.height -  bottomMargin - cornerRaius);
        let bottomLeftArcCenter = CGPoint(x:cornerRaius, y:self.frame.height - bottomMargin - cornerRaius);
        
        let path = UIBezierPath()
//            [UIBezierPath bezierPath];
        // 从左上倒角的下边开始画
        path.move(to: CGPoint(x: 0, y: topMargin + cornerRaius))
        
        path.addLine(to: CGPoint(x: 0, y: bottomLeftArcCenter.y))
        path.addArc(withCenter: bottomLeftArcCenter, radius: cornerRaius, startAngle: -.pi, endAngle: -.pi + (-.pi/2), clockwise: false)
        
        if (isReverse) {
            path.addLine(to: CGPoint(x: arrowPosition, y: self.frame.height - Const.arrowHeight))
            path.addLine(to: CGPoint(x: arrowPosition + 0.5 * Const.arrowWidth, y: self.frame.height))
            path.addLine(to: CGPoint(x: arrowPosition + Const.arrowWidth, y: self.frame.height - Const.arrowHeight))
        }

        path.addLine(to: CGPoint(x: self.frame.width - cornerRaius, y: self.frame.height - bottomMargin));
        path.addArc(withCenter: bottomRightArcCenter, radius: cornerRaius, startAngle: -.pi + (-.pi/2), endAngle: -.pi*2, clockwise: false)

        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - bottomMargin + cornerRaius));
        path.addArc(withCenter: topRightArcCenter, radius: cornerRaius, startAngle: 0, endAngle: -.pi/2, clockwise: false)
        
        if (!isReverse) {
            path.addLine(to: CGPoint(x: arrowPosition + Const.arrowWidth, y: topMargin))
            path.addLine(to: CGPoint(x: arrowPosition + 0.5 * Const.arrowWidth, y: 0))
            path.addLine(to: CGPoint(x: arrowPosition, y: topMargin))
        }
        
        path.addLine(to: CGPoint(x: cornerRaius, y: topMargin))
        path.addArc(withCenter: topLeftArcCenter, radius: cornerRaius, startAngle: (-.pi/2), endAngle:-.pi, clockwise: false)
        path.close()
        maskLayer.path = path.cgPath
        return maskLayer
        
        
    }
    func setupData(){
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        
    }
    
    // MARK: ------------------------- Methods
    public  func show(){
        if needReload {
            reloadData()
        }
        UIApplication.shared.keyWindow?.addSubview(self.bgView)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: Const.animationTime) {
            self.alpha = 1.0
            self.bgView.alpha = 1.0
        }
    }
    
    public  func reloadData(){
        self.contentView?.removeFromSuperview()
        self.tableView?.removeFromSuperview()
        self.contentView = nil
        self.tableView = nil
        setupView()
    }
      @objc public func dismiss(){
        if !dismissOnTouchOutside {return}
        UIView.animate(withDuration: Const.animationTime) {
            self.alpha = 0.0
            self.bgView.alpha  = 0.0
        } completion: { _ in
            self.removeFromSuperview()
            self.bgView.removeFromSuperview()
        }

    }
    
}

extension SPMenuView: UITableViewDataSource,UITableViewDelegate{
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.params.dataArr.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SPMenuCell = tableView.dequeueReusableCell(withIdentifier: Const.CellIdentifier, for: indexPath) as! SPMenuCell
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.text = self.params.dataArr[indexPath.row]
        
        cell.textLabel?.textColor = textColor
        cell.textLabel?.font = textFont
        cell.updateSeparatorLineColor(separatorColor: separatorColor)
        if (indexPath.row == self.params.dataArr.count  - 1) {
            cell.updateShowSeparator(isShow: false)
        }
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = self.params.dataArr[indexPath.row]
        if dismissOnselected  {
            self.dismiss()
        }
        self.callBackBlock?(self,title,indexPath.row)
        

    }
}

class SPMenuCell: UITableViewCell {
    
    // MARK: ------------------------- Propertys
    var isShowSeparator: Bool = true
    
    var separatorLineColor: UIColor = UIColor.lightGray
    
    // MARK: ------------------------- CycLife
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateSeparatorLineColor(separatorColor: UIColor){
        separatorLineColor = separatorColor
        setNeedsDisplay()
    }
    
    func updateShowSeparator(isShow:Bool){
        isShowSeparator  = isShow
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if !isShowSeparator {return}
        let path = UIBezierPath(rect: CGRect(x: 0, y: rect.size.height - 0.5, width: rect.size.width, height: 0.5))
        separatorLineColor.setFill()
        path.fill(with: .normal, alpha: 1.0)
        path.close()
    }
    
    // MARK: ------------------------- Events
    
    // MARK: ------------------------- Methods
    
}
