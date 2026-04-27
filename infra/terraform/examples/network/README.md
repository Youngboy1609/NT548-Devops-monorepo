# Vi du network

Vi du nay tao network dung theo yeu cau de bai:

- 1 VPC
- 1 public subnet
- 1 private subnet
- 1 Internet Gateway
- 1 NAT Gateway
- 1 public route table
- 1 private route table

## Kiem tra

- Public subnet di Internet: `0.0.0.0/0` trong public route table tro toi Internet Gateway.
- Private subnet di ra ngoai: `0.0.0.0/0` trong private route table tro toi NAT Gateway.

## Lenh chay

```powershell
terraform init
terraform validate
terraform plan
```
