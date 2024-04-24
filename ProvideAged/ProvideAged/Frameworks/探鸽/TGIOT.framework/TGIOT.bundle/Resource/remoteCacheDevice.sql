CREATE TABLE "remoteCacheDevice" (
    "id" integer DEFAULT 0 PRIMARY KEY AUTOINCREMENT,
    "deviceId" text,
    "userId" text,
    "updateInfo" text,
    "featureInfo" text,
    "deviceInfo" text,
    "ssid" text,
    "coverImage" blob,
    "deviceName" text,
    "customInfo" text,
    "livePIPCoverImage" blob
);
