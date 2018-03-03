@testable import paybear_ios

import Quick
import Nimble

class Tests: QuickSpec {
    
    override func spec() {
        beforeEach {
            // Public token. Easy there wise guy
            Paybear.shared.setToken("pub9f2d5e3db59b6db40b57f83d9a33437f")
        }
        
        describe("fetch currencies") {
            it("should get an array of CryptoCurrency objects with attributes.") {
                waitUntil(action: { (done) in
                    Paybear.shared.getCurrencies { (currencies, error) in
                        if let currencies = currencies, error == nil {
                            for currency in currencies {
                                expect(currency.title).toNot(beNil())
                                expect(currency.code).toNot(beNil())
                                expect(currency.rate).to(beGreaterThan(0.0))
                            }
                            done()
                        }
                    }
                })
            }
            
            describe("fetch market rates") {
                it("should get an array of Rate objects with attributes.") {
                    waitUntil(action: { (done) in
                        Paybear.shared.getMarketRates(fiat: .usd) { (rates, error) in
                            if let rates = rates, error == nil {
                                for rate in rates {
                                    expect(rate.name).toNot(beNil())
                                    // expect(rate.poloniex).to(beGreaterThan(0.0))  nil
                                    // expect(rate.hitbtc).to(beGreaterThan(0.0))
                                    // expect(rate.bittrex).to(beGreaterThan(0.0)) nil
                                    // expect(rate.bitfinex).to(beGreaterThan(0.0)) nil
                                    // expect(rate.mid).to(beGreaterThan(0.0))
                                }
                                done()
                            }
                        }
                    })
                }
            }
            
            describe("fetch single market rate") {
                it("should get an array of Rate objects with attributes.") {
                    waitUntil(action: { (done) in
                        Paybear.shared.getSingleMarketRate(fiat: .usd, crypto: .btc, completion: { (rate, error) in
                            if let rate = rate, error == nil {
                                expect(rate.poloniex).toNot(beNil())
                                done()
                            }
                        })
                    })
                }
            }
            
            describe("create a payment request") {
                it("should create a payment request") {
                    waitUntil(action: { (done) in
                        Paybear.shared.createPaymentRequest(crypto: .btc, callbackURL: "http://ryans.online", completion: { (request, error) in
                            if let request = request, error == nil {
                                expect(request.invoice).toNot(beNil())
                                expect(request.address).toNot(beNil())
                                done()
                            }
                        })
                    })
                }
            }
            
            describe("login user") {
                it("should login a user and return a token") {
                    waitUntil(action: { (done) in
                        Paybear.shared.login(email: "", password: "", twoFactorDelegate: nil) { (token, error) in
                            if let token = token, error == nil {
                                expect(token).toNot(beEmpty())
                                expect(error).to(beNil())
                                done()
                            }
                        }
                    })
                }
            }
            
            describe("two-factor authentication") {
                it("should prove it can send a two-factor auth code") {
                    waitUntil(action: { (done) in
                        Paybear.shared.loginTwoFactor(code: "12345", completion: { (success) in
                            done()
                        })
                    })
                }
            }
            
            describe("get a user") {
                beforeSuite {
                    
                }
                it("should get a user and their wallets") {
                    waitUntil(action: { (done) in
                        Paybear.shared.getUser(completion: { (user, error) in
                            if let user = user, error == nil {
                                expect(user.name).toNot(beNil())
                                expect(user.email).toNot(beNil())
                                expect(user.lastIP).toNot(beNil())
                                expect(user.wallets.count).to(beGreaterThanOrEqualTo(7)) // Current supported currencies
                                done()
                            }
                        })
                    })
                }
            }
        }
    }
}
