CREATE TABLE "localCacheDevice" (
    "id" integer DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
    "ssid" text,
    "featureInfo" text,
    "deviceInfo" text,
    "customInfo" text,
    "coverImage" blob,
    "deviceName" text,
    "p2pId" text,
    "password" text,
    "livePIPCoverImage" blob
);
