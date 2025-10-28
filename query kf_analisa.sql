CREATE OR REPLACE TABLE `rakamin-kf-analytics-475510.kimia_farma.kf_analisa` AS
SELECT  
  ft.transaction_id, 
  ft.date,  
  ft.branch_id,  
  kc.branch_name,  
  kc.kota,  
  kc.provinsi,  
  kc.rating AS rating_cabang,  
  ft.customer_name,  
  ft.product_id,  
  p.product_name,  
  p.price AS actual_price,  
  ft.discount_percentage,
  ft.rating AS rating_transaksi,   

-- Persentase Gross Laba berdasarkan harga obat
  CASE  
    WHEN p.price <= 50000 THEN 0.10  
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15  
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20  
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25  
    WHEN p.price > 500000 THEN 0.30  
  END AS persentase_gross_laba,  

-- Harga setelah diskon
  (p.price * (1-ft.discount_percentage)) AS nett_sales,  

-- Keuntungan bersih
  (p.price *  
    (CASE  
      WHEN p.price <= 50000 THEN 0.10  
      WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15  
      WHEN p.price > 100000 AND p.price <= 300000 THEN 0.20  
      WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25  
      WHEN p.price > 500000 THEN 0.30  
    END)  
  ) AS nett_profit,  

FROM  
  `rakamin-kf-analytics-475510.kimia_farma.kf_final_transaction` ft  
JOIN  
  `rakamin-kf-analytics-475510.kimia_farma.kf_kantor_cabang` kc  
ON  
  ft.branch_id = kc.branch_id  
JOIN  
  `rakamin-kf-analytics-475510.kimia_farma.kf_product` p  
ON  
  ft.product_id = p.product_id;