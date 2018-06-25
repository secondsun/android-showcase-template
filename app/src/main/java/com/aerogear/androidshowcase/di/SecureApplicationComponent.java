package com.aerogear.androidshowcase.di;

import android.app.Application;
import android.content.Context;
import com.aerogear.androidshowcase.SecureApplication;
import com.aerogear.androidshowcase.domain.crypto.AesCrypto;
import com.aerogear.androidshowcase.features.authentication.providers.OpenIDAuthenticationProvider;
import dagger.BindsInstance;
import dagger.Component;
import dagger.android.AndroidInjectionModule;
import javax.inject.Singleton;

/**
 * Define the dependencies of the app. Used by Dagger2 to build dependency graph.
 */
@Singleton
@Component(modules = {AndroidInjectionModule.class, SecureApplicationModule.class,
    MainActivityModule.class})
public interface SecureApplicationComponent {

    @Component.Builder
    interface Builder {

        @BindsInstance
        Builder application(Application application);

        SecureApplicationComponent build();
    }

    void inject(SecureApplication app);

    Context context();

    AesCrypto provideAesCrypto();

    OpenIDAuthenticationProvider authProvider();

}
