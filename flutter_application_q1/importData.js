// populate.js
const admin = require('firebase-admin');

// ---- IMPORTANT ----
// Replace with the path to your downloaded service account key JSON file
const serviceAccount = require('./serviceAccountKey.json'); // Make sure this path is correct

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

// --- Data to Populate (Matches your UI image, with more popular products) ---

const bannersData = [
  {
    titlePart1: "Shop with ",
    titlePart2: "100% cashback",
    subtitle: "On Shopee",
    buttonText: "I want!",
    offerText: "Best offer!",
    imageUrl: "https://www.pngall.com/wp-content/uploads/5/Headphone-Transparent.png"
  }
  // You can add more banner items here if your design supports multiple banners in the carousel
  // Example:
  // {
  //   titlePart1: "Save Big on ",
  //   titlePart2: "Electronics",
  //   subtitle: "Limited Time Deals",
  //   buttonText: "Shop Now",
  //   offerText: "Up to 50% Off!",
  //   imageUrl: "https://via.placeholder.com/400x200.png?text=Electronics+Sale"
  // }
];

const categoriesData = [
  { name: "Earn 100%", iconName: "percent" },
  { name: "Tax note", iconName: "description_outlined" },
  { name: "Primum", iconName: "diamond_outlined" },
  { name: "Challenge", iconName: "emoji_events_outlined" },
  { name: "More", iconName: "more_horiz" }
];

const popularProductsData = [
  {
    name: "Monitor LED 4K 28\"",
    imageUrl: "https://images.samsung.com/is/image/samsung/p6pim/sa_en/ls28bg700emxue/gallery/sa_en-odyssey-g7-g70b-ls28bg700emxue-534082512?$730_584_PNG$",
    cashback: "2% cashback", // Note: UI shows cashback, not price. Adjust if "price" is a strict req.
    isFavorite: false
  },
  {
    name: "Row balance 480 low",
    imageUrl: "https://www.converse.com/dw/image/v2/BCMP_PRD/on/demandware.static/-/Sites-converse-master-catalog/default/dw9959042f/images/a_08/A00707C_A_08X1.jpg?sw=406",
    cashback: "8%cashback",
    isFavorite: false
  },
  {
    name: "Gaming Mouse Pro",
    imageUrl: "https://resource.logitechg.com/w_600,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/gaming/en/products/pro-x-superlight/pro-x-superlight-black-gallery-1.png?v=1",
    cashback: "5% cashback",
    isFavorite: false
  },
  {
    name: "Wireless Earbuds X",
    imageUrl: "https://www.beatsbydre.com/content/dam/beats/web/product/earbuds/studiopbuds-plus/pdp/product-carousel/transparent/pc-studiopbuds-plus-transparent-v2.png",
    cashback: "10% cashback",
    isFavorite: true // Example of a favorited item
  },
  {
    name: "Smart Watch Series 7",
    imageUrl: "https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/ML6H3_VW_34FR+watch-41-alum-midnight-nc-7s_VW_34FR_WF_CO_GEO_FR?wid=700&hei=700&trim=1%2C0&fmt=p-jpg&qlt=95&.v=1631832067000%2C1632174302000",
    cashback: "3% cashback",
    isFavorite: false
  }
];

// --- Population Functions (Same as before) ---

async function populateCollection(collectionName, dataArray) {
  const collectionRef = db.collection(collectionName);
  const batch = db.batch();

  // Optional: Clear existing data. Uncomment to use.
  // console.log(`Clearing existing data in '${collectionName}'...`);
  // const snapshot = await collectionRef.get();
  // if (!snapshot.empty) {
  //   snapshot.docs.forEach(doc => batch.delete(doc.ref));
  //   await batch.commit(); // Commit deletions
  //   console.log(`Cleared ${snapshot.size} documents from '${collectionName}'.`);
  // }
  // const newBatch = db.batch(); // Start a new batch for adding if you cleared

  dataArray.forEach(item => {
    const docRef = collectionRef.doc(); // Auto-generate ID
    batch.set(docRef, item); // Use batch, or newBatch if you cleared
  });

  try {
    await batch.commit(); // Commit additions
    console.log(`Successfully populated ${dataArray.length} documents in '${collectionName}' collection.`);
  } catch (error) {
    console.error(`Error populating '${collectionName}' collection:`, error);
  }
}

async function main() {
  console.log("Starting Firestore population script...");
  await populateCollection('banners', bannersData);
  await populateCollection('categories', categoriesData);
  await populateCollection('popular_products', popularProductsData);
  console.log("Firestore population script finished.");
}

main().catch(console.error);