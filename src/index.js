const express = require("express");
const {execute, get, table, where, update} = require("./database");

const config = require("./config.json");
const PORT = config.port;

const app = express();
const router = express.Router();

let balanceColumn = "current";
let authKey;

/**
 * @brief Promise voor het instellen van de router
 *
 */
router.use((req, res, next) => {
    console.log("[info]\t\tMiddleware ingeschakeld!");
    table("rekening");
    get();

    let q = execute();
    console.log(q);

    next();
});

router.param("authKey", (req, res, next, id) => {
    console.log("[info]\t\tRouter param aangeroepen");

    authKey = req.params.authKey;

    if (req.params.authKey === "1234") {
        next();
    } else {
        console.log("[error]\t\tU heeft niet de juiste bevoegdheid om de API te gebruiken!");
        res.redirect("/api/error/401");
    }
});


/**
 *@brief Promise voor het handelen van de home routing
 *
 */
router.get("/api/:authKey/balance/get", async (req, res, next) => {
    // When auth key is provided and balance is requested
    table("rekening");
    where([`IBAN`, '=', authKey]);
    get([balanceColumn]);
    let q = await execute();

    // console.log(q);

    balanceAmount = q[0].current;
    // balanceAmount = 123.45;

    res.json({
        balance: balanceAmount,
        request: 200,
        message: "Success"
    })
});

router.post("/api/:authKey/balance/post", async (req, res, next) => {
    // When auth key is provided and balance is requested
    table("rekening");
    where([`IBAN`, '=', authKey]);
    get([balanceColumn]);
    let q = await execute();

    // console.log(q);

    balanceAmount = q[0].current;
    // balanceAmount = 123.45;

    res.json({
        balance: balanceAmount,
        request: 200,
        message: "Success"
    })
});

router.get("/api/:authKey/withdraw/get", async (req, res, next) => {
    // When auth key is provided and user wants to withdraw money
    table("rekening");
    where([`IBAN`, '=', authKey]);
    get([balanceColumn]);
    let q = await execute();

    withdrawAmount = 10; // Connect to ATM
    oldBalanceAmount = q[0].current; // Connect to DB

    table("rekening")
    where([`IBAN`, '=', authKey]);
    update({
        'current': oldBalanceAmount - withdrawAmount
    });
    q = await execute();

    res.json({
        withdraw: withdrawAmount,
        oldBalance: oldBalanceAmount,
        newBalance: q,
        request: 200,
        message: "Success"
    })
});

router.post("/api/:authKey/withdraw/post", (req, res, next) => {
    // When auth key is provided and user wants to withdraw money
    withdrawAmount = 10; // Connect to ATM
    oldBalanceAmount = 123.45; // Connect to DB

    res.json({
        withdraw: withdrawAmount,
        oldBalance: oldBalanceAmount,
        newBalance: (oldBalanceAmount - withdrawAmount), // Make variable for DB
        request: 200,
        message: "Success"
    })
});

router.get("/api/error/401", (req, res, next) => {
    res.json({
        request: 401,
        message: "Not authorized"
    });
});


/**
 * @brief Functie voor het runnen van de webserver
 *
 */
app.use('/', router);
app.listen(PORT, () => {
    console.log(`[info]\t\tServer is running on port: ${PORT}`);
    console.log(`[info]\t\thttp://localhost:${PORT}`)
});
