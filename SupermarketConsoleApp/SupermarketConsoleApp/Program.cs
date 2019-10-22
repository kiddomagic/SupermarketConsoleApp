using ConsoleTables;
using SupermarketConsoleApp.ViewModel;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SupermarketConsoleApp
{
    class Program
    {

        static SupermarketDBEntities dBEntities = new SupermarketDBEntities();

        static void Checkout()
        {
            ConsoleTable table = new ConsoleTable("Receipt");
            var code = "";
            var orders = new Dictionary<string, float>();
            Order ord = new Order
            {
                No = 400000 + dBEntities.Orders.Count() + 1,
                DateTime = DateTime.Now
            };
            dBEntities.Orders.Add(ord);
            dBEntities.SaveChanges();
            Console.WriteLine("=======================================================");
            do
            {
                Console.Write("Product code: ");
                code = Console.ReadLine();
                if (orders.ContainsKey(code))
                {
                    var temp = (float)0;
                    do
                    {
                        Console.Write("Quantity: ");
                        temp = float.Parse(Console.ReadLine());
                        if(temp > 0)
                        {
                            orders[code] += temp;
                        }
                        else
                        {
                            Console.WriteLine("Your input must be lareger than 0");
                        }
                    }
                    while (temp <= 0);
                }

                if (!code.Equals("E0") && !orders.ContainsKey(code))
                {
                    var value = (float)0;
                    do
                    {
                        Console.Write("Quantity: ");
                        value = float.Parse(Console.ReadLine());
                        if (value > 0)
                        {
                            orders.Add(code, value);
                        }
                        else
                        {
                            Console.WriteLine("Your Input must larger than 0");
                        }
                    }
                    while (value <= 0);
                }
                Console.WriteLine("-------------------------------------------------------");
            }
            while (!code.Equals("E0"));            
            var total = 0;            
            var vegPromo = false;            
            foreach (var order in orders)
            {
                var product = dBEntities.Products.Where(p => p.ProductCode.Equals(order.Key));
                float temp = product.First().Price;
                OrderDataModel tmp = new OrderDataModel
                {
                    ProductCode = product.First().ProductCode,
                    ProuctName = product.First().ProductName,                                        
                };
                var pr = order.Value * product.First().Price;
                tmp.Price = (int)pr;                             
                var row = string.Format("{0} - {1}: {2}", tmp.ProductCode, tmp.ProuctName, tmp.Price);
                var flag = dBEntities.Promotions.Where(p => p.StartDate <= DateTime.Now && p.EndDate >= DateTime.Now && p.ProductCode == product.FirstOrDefault().ProductCode).Count() != 0;
                if (flag)
                {
                    var discounts = dBEntities.Promotions.Where(p => p.StartDate <= DateTime.Now && p.EndDate >= DateTime.Now && p.ProductCode == product.FirstOrDefault().ProductCode);
                    foreach (var discount in discounts)
                    {
                        if(discount.TypeId == 2)
                        {
                            tmp.Price -= tmp.Price * (int)discount.SalePercent / 100;
                            row = string.Format("{0} - {1}: {2} Discount {3}%", tmp.ProductCode, tmp.ProuctName, tmp.Price, discount.SalePercent);                            
                        }
                        else
                        {
                            if(order.Value % discount.RequiredQuantity == 0)
                            {
                                row = string.Format("{0} - {1}: {2} Free {3}", tmp.ProductCode, tmp.ProuctName, tmp.Price, (discount.QuantityDiscount * (order.Value / discount.RequiredQuantity)) );                                
                            }
                            else
                            {
                                if(order.Value > 1)
                                {
                                    int free = (int)(discount.QuantityDiscount * (order.Value / discount.RequiredQuantity));
                                    row = string.Format("{0} - {1}: {2} Free {3}", tmp.ProductCode, tmp.ProuctName, tmp.Price, free);                                    
                                }
                            }
                        }
                    }
                }                
                if (product.First().TypeId == 2)
                {
                    total += (tmp.Price - tmp.Price / 100);
                    vegPromo = true;
                }
                else
                {
                    total += tmp.Price;
                }
                table.AddRow(row);
                OrderItem item = new OrderItem
                {
                    OrdItemNo = ord.No * 1000 + dBEntities.OrderItems.Where(o => o.OrdItemNo/1000 == ord.No).Count() + 1,
                    OrderNo = ord.No,
                    ItemId = tmp.ProductCode,
                    Price = tmp.Price
                };
                dBEntities.OrderItems.Add(item);
                dBEntities.SaveChanges();
            }
            Console.Write("Membership Yes(1)/ No (0): ");            
            var is_mem = int.Parse(Console.ReadLine());            
            Console.WriteLine("=======================================================");
            Console.WriteLine("");
            if (vegPromo)
            {
                table.AddRow("Promotion for Vegetable: Yes");
            }
            else
            {
                table.AddRow("Promotion for Vegetable: No");
            }
            if (is_mem == 1)
            {
                total -= total * 10 / 100;
                table.AddRow("Membership: Yes");
            }
            else
            {
                table.AddRow("Membership: No");
            }
            table.AddRow(string.Format("Total: {0}", total));            
            table.Write(Format.MarkDown);
        }

        static void PriceManagement()
        {
            Console.WriteLine("======================================================= ");
            var code = "";
            do
            {
                Console.Write("Product code: ");
                code = Console.ReadLine();
                if (!code.Equals("E0"))
                {
                    var product = new Product();
                    if (dBEntities.Products.Where(p => p.ProductCode.Equals(code)) != null)
                    {
                        product = dBEntities.Products.Where(p => p.ProductCode.Equals(code)).First();
                    }
                    Console.WriteLine("Current price: {0}/{1}", product.Price, product.Unit);
                    var price = 0;
                    do
                    {
                        Console.Write("New price: ");
                        price = int.Parse(Console.ReadLine());
                        if(price <= 0)
                        {
                            Console.WriteLine("Your input must be less than 0");
                        }
                    }
                    while (price <= 0);                    
                    Console.WriteLine("------------------------------------------------------");
                    product.Price = price;
                    dBEntities.Entry(product).State = EntityState.Modified;
                    dBEntities.SaveChanges();
                }
                else
                {
                    Console.WriteLine("======================================================\n");                    
                }
            }
            while (!code.Equals("E0"));
        }

        static void PromotionManagement()
        {
            Console.WriteLine("=======================================================");
            var code = "";
            do
            {
                Console.Write("Product code: ");
                code = Console.ReadLine();
                if (!code.Equals("E0"))
                {
                    Promotion promotion = new Promotion();
                    if(dBEntities.Promotions.Count() == 0)
                    {
                        promotion.Id = 1;
                    }
                    else
                    {
                        promotion.Id = dBEntities.Promotions.Count() + 1;
                    }
                    var flag = false;
                    do
                    {
                        Console.Write("Promotion Type: ");
                        promotion.TypeId = int.Parse(Console.ReadLine());
                        if (promotion.TypeId == 1 && code.ElementAt(0) != 'H')
                        {
                            Console.WriteLine("This promotion only applicable for household items!");
                        }
                        else
                        {
                            flag = true;
                        }
                    }
                    while (!flag);                    
                    promotion.ProductCode = code;
                    promotion.StartDate = DateTime.Now.Date;
                    promotion.EndDate = promotion.StartDate.AddDays(28);
                    var temp = 0;
                    if (promotion.TypeId == 1)
                    {
                        promotion.SalePercent = 0;
                        do
                        {
                            do
                            {
                                Console.Write("Quantity Required: ");
                                temp = int.Parse(Console.ReadLine());
                                if (temp <= 0)
                                {
                                    Console.WriteLine("Your input must greater than 0");
                                }
                                else
                                {
                                    promotion.RequiredQuantity = temp;
                                }
                            }
                            while (temp <= 0);
                            do
                            {
                                Console.Write("Quantity Discount: ");
                                temp = int.Parse(Console.ReadLine());
                                if (temp <= 0)
                                {
                                    Console.WriteLine("Your input must greater than 0");
                                }
                                else
                                {
                                    promotion.QuantityDiscount = temp;
                                }
                            }
                            while (temp <= 0);
                            if (promotion.RequiredQuantity < promotion.QuantityDiscount)
                            {
                                Console.WriteLine("The quantity discount must be less or equal to require quantity!");
                            }
                        }
                        while (promotion.RequiredQuantity < promotion.QuantityDiscount);
                    }
                    else
                    {
                        promotion.RequiredQuantity = 0;
                        promotion.QuantityDiscount = 0;
                        do
                        {
                            Console.Write("Discount (percentage): ");
                            promotion.SalePercent = int.Parse(Console.ReadLine());
                            if (promotion.SalePercent <= 0)
                            {
                                Console.WriteLine("Your input must be greater than 0");
                            }
                            if (promotion.SalePercent == 100)
                            {
                                Console.WriteLine("The Percentage sale must be less than 100");
                            }
                        }
                        while (promotion.SalePercent <= 0 || promotion.SalePercent == 100);
                    }
                    Console.WriteLine("-------------------------------------------------------");
                    dBEntities.Promotions.Add(promotion);
                    dBEntities.SaveChanges();
                }
                else
                {
                    Console.WriteLine("=======================================================\n");
                }
            }
            while (!code.Equals("E0"));            
        }

        static void MainMenu()
        {
            var choice = 0;
            do
            {
                ConsoleTable table = new ConsoleTable("Low Price management Features ");
                table.AddRow("1. Checkout");
                table.AddRow("2. Price management");
                table.AddRow("3. Promotion management");
                table.AddRow("4. Exit");
                table.Write(Format.Alternative);
                Console.Write("Select a feature: ");
                choice = int.Parse(Console.ReadLine());
                Console.WriteLine("");
                switch (choice)
                {
                    case 1:
                        Checkout();
                        break;
                    case 2:
                        PriceManagement();
                        break;
                    case 3:
                        PromotionManagement();
                        break;
                    case 4:
                        Environment.Exit(0);
                        break;
                }
            }
            while (choice != 4);            
        }

        static void Main(string[] args)
        {
            MainMenu();
        }
    }
}
