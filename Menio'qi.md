
# Menio'qi

## Loyihaning nomi

**n8n bilan ngrokni avtomatik o'rnatish**

## Loyihaning tavsifi

Ushbu loyiha `n8n` ni Docker ichida ishga tushirish va `ngrok` orqali ommaviy URL bilan ulash uchun tayyor avtomatlashtirilgan ish oqimini taqdim etadi. U oson o'rnatish, deploy va yangilash uchun skriptlar va konfiguratsiyalarni o'z ichiga oladi, shu bilan birga loglarni boshqarish, webhooklarni avtomatik yangilash va xavfsiz ma'lumot ishlov berishni ta'minlaydi.

---

## Asosiy xususiyatlar

- **Docker orqali n8n**: n8n konteynerda ishlaydi, bu muhitni bir xil va ko'chiriladigan qiladi.
- **ngrok integratsiyasi**: n8n ni ommaviy URL orqali ochish uchun ngrok avtomatik sozlanadi.
- **Webhooklarni avtomatik yangilash**: ngrok ishga tushganda webhook URL larini yangilaydigan skript mavjud.
- **Systemd xizmati uchun ngrok**: ngrok fon rejimida ishlashi va server qayta yuklanganda qayta ishga tushishini ta'minlaydi.
- **Loglarni boshqarish**: loglar fayllarga yoziladi va `logrotate` bilan boshqariladi.
- **Idempotent o'rnatish**: `install.sh` ngrok, systemd xizmat va logrotate ni sozlashni amalga oshiradi.
- **Bir buyruqda deploy**: `deploy.sh` ngrok ni ishga tushiradi, webhook larni yangilaydi va `docker compose up -d` ni bajaradi.
- **n8n ma'lumotlar boshqaruvi**: `n8n-data` papkasi mavjudligini va to'g'ri ruxsatlarni ta'minlaydi.

---

## Papka tuzilishi

```
n8n-Automated-Deployment-with-ngrok/
├─ docker-compose.yml
├─ .env.example          # Muhit o'zgaruvchilari shabloni (.env ga nusxalang)
├─ install.sh            # Birinchi marta o'rnatish skripti
├─ deploy.sh             # Deploy skripti
├─ update-ngrok-webhook.sh  # ngrok URL ga moslab webhook ni yangilaydi
├─ ngrok.yml             # ngrok konfiguratsiyasi
├─ n8n-data/             # Doimiy n8n ma'lumot papkasi (Gitda e'tiborga olinmaydi)
├─ Makefile (ixtiyoriy)  # Yordamchi buyruqlar
└─ README.md
```

---

## O'rnatish va deploy

```bash
# Repozitoriyani klonlash
git clone https://github.com/khumoyun1998/n8n-Automated-Deployment-with-ngrok.git

# Birinchi marta sozlash
sudo ./install.sh

# Dastlabki deploy
./deploy.sh

# webhook ni sozlash
./update-ngrok-webhook.sh
```

yoki

```bash
# Repozitoriyani klonlash
git clone https://github.com/khumoyun1998/n8n-Automated-Deployment-with-ngrok.git

make up
```

---

PS: `ngrok.yml` faylida HAM `authtoken` ni, HAM bepul `static domain` ni (ngrok dashboard → Domains) belgilang. Static domain URL ni restartlarda o'zgarmas qiladi, shu tufayli Telegram webhook hech qachon buzilmaydi.

## Autentifikatsiya

n8n 1.0+ eski `N8N_BASIC_AUTH_*` o'zgaruvchilarini olib tashladi. Himoya endi
n8n ning ichki **foydalanuvchi boshqaruvi** orqali amalga oshiriladi — ommaviy
URL ni birinchi ochganingizda n8n owner (egasi) akkauntini yaratishni so'raydi.
ngrok URL ochiq bo'lgani uchun buni darhol bajaring.

## Talablar

- Linux server (Ubuntu/Debian tavsiya etiladi)
- ngrok hisobi (authtoken uchun)
- Make o'rnatilgan
- Git o'rnatilgan

---

## Foydalari

- Har qanday serverga oson, takrorlanadigan deploy
- Loglar avtomatik aylanadi va boshqariladi
- ngrok tunnel lari doimiy va webhook lar avtomatik yangilanadi

