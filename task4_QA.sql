﻿-- Kiểm tra xem có CSDL Task04 chưa
if exists (select * from sys.databases where name ='Task04')
	drop database Task04
go
-- tạo lại CSDL Task04
create database Task04
go
-- Sử dụng CSDL Task04
use Task04
go
-- Tạo bảng lưu trữ thông tin khách hàng
create table Customer(
	CustomerID int primary key,
	CustomerName nvarchar(150),
	CustomerAddress nvarchar(300),
	Tel varchar(40)
)
go
-- Tạo bảng lưu trữ sản phẩm trong kho
create table Product(
	ProductID varchar(40) primary key,
	ProductName nvarchar(200),
	Unit nvarchar(40),
	Price money,
	Quantity int,
	ProductStatus nvarchar(300)
)
go
-- Tạo bảng lưu trữ Đơn Hàng
create table Orders(
	OrderID varchar(40) primary key,
	CustomerID int foreign key references Customer(CustomerID),
	OrderDate date
)
go
-- Tạo bảng lưu trữ thông tin chi tiết Đơn hàng
create table OrderDetails(
	OrderID varchar(40) foreign key references Orders(OrderID),
	ProductID varchar(40) foreign key references Product(ProductID),
	OrderStatus nvarchar(300),
	Price money,
	Quantity int
)
go
-- Thêm dữ liệu vào các bảng
insert into Customer(CustomerID, CustomerName, CustomerAddress, Tel)
	values
		(123, N'Đinh Quang Anh', N'Hà Đông-Hà Nội', '(+84) 395100761'),
		(124, N'Vũ Viết Quý', N'Thái Bình', '(+84) 123456789'),
		(125, N'Tạ Duy Linh', N'Thái Nguyên', '(+84) 987654321')
go
insert into Product(ProductID, ProductName, ProductStatus, Unit, Price, Quantity)
	values
		('LAP1', N'Laptop Lenovo ThinkBook', N'Hàng mới về', N'Chiếc', 23999000, 50),
		('LAP2', N'Laptop ASUS', N'Hàng tồn kho', N'Chiếc', 13499000, 10),
		('SMP1', N'SmartPhone SamSung Z Flip3', N'Điện thoại đang hot', N'Chiếc', 69999000, 20)
go
insert into Orders (OrderID, CustomerID, OrderDate)
	values
		('ord1', 123, '20211224'),
		('ord2', 124, '20211225'),
		('ord3', 125, '20211226'),
		('ord4', 123, '20211224')
go
insert into OrderDetails(OrderID, ProductID, OrderStatus, Price, Quantity)
	values
		('ord1', 'LAP1', N'Đã nhận đơn', 23999000, 2),
		('ord1', 'LAP2', N'Đã nhận đơn', 13499000, 3),
		('ord2', 'LAP1', N'Đang Kiểm Tra', 13499000, 3),
		('ord3', 'SMP1', N'Đang giao hàng', 6999000, 10),
		('ord4', 'SMP1', N'Đang giao hàng', 6999000, 10)
-- 4. Câu lệnh truy vấn
	-- Liệt kê danh sách khách hàng đã mua ở cửa hàng
	select CustomerName from Customer 
	where CustomerID in (
		select CustomerID from Orders
	)
	-- Liệt kê danh sách sản phẩm của cửa hàng
	select ProductName from Product
	-- Liệt kê danh sách các đơn hàng của cửa hàng
	select OrderID from Orders
-- 5. Câu lệnh truy vấn
	-- Liệt kê danh sách khách hàng theo thứ tự alphabet
	select CustomerName from Customer
	order by CustomerName 
	-- Liệt kê danh sách sản phẩm của cửa hàng theo thứ từ giá giảm dần
	select ProductName,Price from Product
	order by Price DESC
	-- Liệt kê sản phẩm mà khách hàng Đinh Quang Anh đã mua
	select ProductName from Product
	where ProductID in (
		select ProductID from OrderDetails
		where OrderID in (
			select OrderID from Orders
			where CustomerID = 123
		)
	)
-- 6. Câu lệnh truy vấn
	-- Số khách hàng đã mua hàng
	select COUNT (Distinct CustomerID) from Orders
	-- Số maẹt hàng mà cửa hàng bán
	select count (ProductID) from Product
	-- Tổng tiền của từng đơn hàng
	select OrderID, sum(Price*Quantity) as 'TotalAmount' from OrderDetails
	group by OrderID 
-- 7. thay Đổi thông tin
	-- Thay đổi trường giá tiền của từng mặt hàng >0
	alter table Product
		add constraint Ck_Product_Price Check(Price > 0) 
	alter table OrderDetails
		add constraint Ck_OrdDetails_Price Check(Price > 0)
	-- Thay đổi ngày đặt hàng nhỏ hơn ngày hiện tại
	alter table Orders
		add constraint Ck_Ord_Date Check (OrderDate < getDate())
	-- Thêm trường ngày xuất hiện của sản phẩm trên thị trường
	alter table Product
		add PublicDate date		 